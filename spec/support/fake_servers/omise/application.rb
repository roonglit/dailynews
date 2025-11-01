require "sinatra/base"
require "json"
require "cgi"
require "uri"

module FakeServers
  module Omise
    # Fake Omise Server for testing payment flows
    # This server mocks the Omise API endpoints used for creating and retrieving charges
    class Application < Sinatra::Base
      # Set environment to test to avoid host authorization restrictions
      set :environment, :test

      # Store charges and customers in memory for retrieval (class variable for persistence)
      @@charges = {}
      @@failed_charge_ids = []
      @@customers = {}

      class << self
        def reset_charges!
          @@charges = {}
          @@failed_charge_ids = []
          @@customers = {}
        end

        def mark_charge_as_failed!(charge_id)
          @@failed_charge_ids << charge_id
        end

        # Load charge template from JSON file
        def load_charge_template(filename)
          file_path = File.join(__dir__, "jsons", filename)
          JSON.parse(File.read(file_path))
        end

        def create_charge(params, template: "charge.json")
          charge_id = "chrg_test_#{SecureRandom.hex(8)}"
          return_uri = params["return_uri"]
          amount = params["amount"].to_i
          card_token = params["card"]
          customer_id = params["customer"]

          # Check if this is a failure token (either from card or from customer's default card)
          is_failure_token = card_token&.include?("failure")
          if !is_failure_token && customer_id
            customer = @@customers[customer_id]
            is_failure_token = customer&.dig("default_card")&.include?("failure")
          end

          # Extract host from return_uri to use same host for authorize_uri
          uri = URI.parse(return_uri)
          base_url = "#{uri.scheme}://#{uri.host}:#{uri.port}"

          # Load template and merge with request params
          charge = load_charge_template(template)
          charge["id"] = charge_id
          charge["location"] = "/charges/#{charge_id}"
          charge["amount"] = amount
          charge["currency"] = params["currency"] || charge["currency"] || "thb"
          charge["return_uri"] = return_uri
          charge["created"] = Time.now.utc.iso8601

          # Set authorize_uri to go directly to verify (skip 3DS for faster tests)
          charge["authorize_uri"] = return_uri

          # Track failure tokens so retrieve_charge returns failed status
          if is_failure_token
            @@failed_charge_ids << charge_id
          end

          # Update nested card if present
          if charge["card"]
            charge["card"]["id"] = "card_test_#{SecureRandom.hex(8)}"
          end

          @@charges[charge_id] = charge
          charge
        end

        def retrieve_charge(charge_id, template: nil)
          charge = @@charges[charge_id]

          if charge
            # Determine which template to use based on whether charge is marked as failed
            template ||= @@failed_charge_ids.include?(charge_id) ? "charge_failed.json" : "charge_paid.json"

            # Merge with appropriate template to get complete charge response
            charge_template = load_charge_template(template)
            charge.merge!(
              "authorized" => charge_template["authorized"],
              "paid" => charge_template["paid"],
              "status" => charge_template["status"],
              "transaction" => charge_template["paid"] ? "trxn_test_#{SecureRandom.hex(8)}" : nil
            )
            charge
          else
            nil
          end
        end

        def create_customer(params)
          customer_id = "cust_test_#{SecureRandom.hex(8)}"

          customer = {
            "object" => "customer",
            "id" => customer_id,
            "livemode" => false,
            "location" => "/customers/#{customer_id}",
            "email" => params["email"],
            "description" => params["description"],
            "default_card" => nil,
            "cards" => {
              "object" => "list",
              "data" => [],
              "limit" => 20,
              "offset" => 0,
              "total" => 0,
              "location" => "/customers/#{customer_id}/cards"
            },
            "created" => Time.now.utc.iso8601
          }

          # If creating with a card token, add the card
          if params["card"] && params["card"].start_with?("tokn_")
            card = create_card_from_token(customer_id, params["card"])
            customer["cards"]["data"] << card
            customer["cards"]["total"] = 1
            customer["default_card"] = card["id"]
          end

          @@customers[customer_id] = customer
          customer
        end

        def retrieve_customer(customer_id)
          @@customers[customer_id]
        end

        def update_customer(customer_id, params)
          customer = @@customers[customer_id]
          return nil unless customer

          # If adding a new card via token, create a card and add it
          if params["card"] && params["card"].start_with?("tokn_")
            card = create_card_from_token(customer_id, params["card"])
            customer["cards"]["data"] << card
            customer["cards"]["total"] = customer["cards"]["data"].length
            customer["default_card"] = card["id"]
          end

          customer["email"] = params["email"] if params["email"]
          customer["description"] = params["description"] if params["description"]

          customer
        end

        def create_card_from_token(customer_id, token)
          # Preserve failure indicator in card_id if token contains "failure"
          if token&.include?("failure")
            card_id = "card_test_failure_#{SecureRandom.hex(8)}"
          else
            card_id = "card_test_#{SecureRandom.hex(11)}"
          end

          {
            "object" => "card",
            "id" => card_id,
            "livemode" => false,
            "location" => "/customers/#{customer_id}/cards/#{card_id}",
            "deleted" => false,
            "brand" => "Visa",
            "last_digits" => "4242",
            "expiration_month" => 12,
            "expiration_year" => 2029,
            "fingerprint" => "kDuzb/MsBhfZhl188OcDQBEhimFLK6PgBWbaybZvAbk=",
            "name" => "Test Cardholder",
            "created_at" => Time.now.utc.iso8601
          }
        end

        def list_cards(customer_id)
          customer = @@customers[customer_id]
          return nil unless customer

          customer["cards"]
        end

        def retrieve_card(customer_id, card_id)
          customer = @@customers[customer_id]
          return nil unless customer

          customer["cards"]["data"].find { |card| card["id"] == card_id }
        end

        def delete_card(customer_id, card_id)
          customer = @@customers[customer_id]
          return nil unless customer

          card = customer["cards"]["data"].find { |c| c["id"] == card_id }
          return nil unless card

          customer["cards"]["data"].delete(card)
          customer["cards"]["total"] = customer["cards"]["data"].length

          # Clear default card if it was deleted
          if customer["default_card"] == card_id
            customer["default_card"] = customer["cards"]["data"].first&.dig("id")
          end

          card.merge("deleted" => true)
        end
      end

      # POST /charges - Create a new charge
      post "/charges" do
        request.body.rewind
        body_content = request.body.read
        request_params = Rack::Utils.parse_nested_query(body_content)

        charge = self.class.create_charge(request_params)

        content_type :json
        status 200
        charge.to_json
      end

      # GET /charges/:id - Retrieve a charge
      get "/charges/:id" do
        charge = self.class.retrieve_charge(params[:id])

        if charge
          content_type :json
          status 200
          charge.to_json
        else
          content_type :json
          status 404
          { error: "Charge not found" }.to_json
        end
      end

      # POST /charges/:id/capture - Capture a charge
      post "/charges/:id/capture" do
        charge = self.class.retrieve_charge(params[:id])

        if charge
          # Mark charge as captured (authorized and paid)
          charge["captured"] = true
          charge["authorized"] = true
          charge["paid"] = true unless @@failed_charge_ids.include?(params[:id])
          charge["status"] = @@failed_charge_ids.include?(params[:id]) ? "failed" : "successful"

          content_type :json
          status 200
          charge.to_json
        else
          content_type :json
          status 404
          { error: "Charge not found" }.to_json
        end
      end

      # GET /fake-3ds/authorize/:charge_id - Simulate 3DS authorization page
      get "/fake-3ds/authorize/:charge_id" do
        charge_id = params[:charge_id]
        return_uri = params[:return_uri]
        charge = @@charges[charge_id]

        if charge
          # Mark charge as authorized and paid
          charge["authorized"] = true
          charge["paid"] = true
          charge["status"] = "successful"
          charge["transaction"] = "trxn_test_#{SecureRandom.hex(8)}"

          redirect return_uri
        else
          status 404
          "Charge not found"
        end
      end

      # GET /fake-3ds/authorize-failed/:charge_id - Simulate failed 3DS authorization
      get "/fake-3ds/authorize-failed/:charge_id" do
        charge_id = params[:charge_id]
        return_uri = CGI.unescape(params[:return_uri] || "")
        charge = @@charges[charge_id]

        if charge
          # Mark charge as failed
          charge["authorized"] = false
          charge["paid"] = false
          charge["status"] = "failed"
          charge["failure_code"] = "insufficient_fund"
          charge["failure_message"] = "Insufficient funds in the account"

          redirect return_uri
        else
          status 404
          "Charge not found"
        end
      end

      # POST /customers - Create a new customer
      post "/customers" do
        request.body.rewind
        body_content = request.body.read
        request_params = Rack::Utils.parse_nested_query(body_content)

        customer = self.class.create_customer(request_params)

        content_type :json
        status 200
        customer.to_json
      end

      # GET /customers/:id - Retrieve a customer
      get "/customers/:id" do
        customer = self.class.retrieve_customer(params[:id])

        if customer
          content_type :json
          status 200
          customer.to_json
        else
          content_type :json
          status 404
          { error: "Customer not found" }.to_json
        end
      end

      # PATCH /customers/:id - Update a customer
      patch "/customers/:id" do
        request.body.rewind
        body_content = request.body.read
        request_params = Rack::Utils.parse_nested_query(body_content)

        customer = self.class.update_customer(params[:id], request_params)

        if customer
          content_type :json
          status 200
          customer.to_json
        else
          content_type :json
          status 404
          { error: "Customer not found" }.to_json
        end
      end

      # GET /customers/:customer_id/cards - List customer's cards
      get "/customers/:customer_id/cards" do
        cards = self.class.list_cards(params[:customer_id])

        if cards
          content_type :json
          status 200
          cards.to_json
        else
          content_type :json
          status 404
          { error: "Customer not found" }.to_json
        end
      end

      # GET /customers/:customer_id/cards/:card_id - Retrieve a specific card
      get "/customers/:customer_id/cards/:card_id" do
        card = self.class.retrieve_card(params[:customer_id], params[:card_id])

        if card
          content_type :json
          status 200
          card.to_json
        else
          content_type :json
          status 404
          { error: "Card not found" }.to_json
        end
      end

      # DELETE /customers/:customer_id/cards/:card_id - Delete a card
      delete "/customers/:customer_id/cards/:card_id" do
        card = self.class.delete_card(params[:customer_id], params[:card_id])

        if card
          content_type :json
          status 200
          card.to_json
        else
          content_type :json
          status 404
          { error: "Card not found" }.to_json
        end
      end
    end
  end
end
