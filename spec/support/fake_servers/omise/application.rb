require "sinatra/base"
require "json"

module FakeServers
  module Omise
    # Fake Omise Server for testing payment flows
    # This server mocks the Omise API endpoints used for creating and retrieving charges
    class Application < Sinatra::Base
      # Set environment to test to avoid host authorization restrictions
      set :environment, :test

      # Store charges in memory for retrieval (class variable for persistence)
      @@charges = {}

      class << self
        def reset_charges!
          @@charges = {}
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

          # Load template and merge with request params
          charge = load_charge_template(template)
          charge["id"] = charge_id
          charge["location"] = "/charges/#{charge_id}"
          charge["amount"] = amount
          charge["currency"] = params["currency"] || charge["currency"] || "thb"
          charge["authorize_uri"] = return_uri
          charge["return_uri"] = return_uri
          charge["created"] = Time.now.utc.iso8601

          # Update nested card if present
          if charge["card"]
            charge["card"]["id"] = "card_test_#{SecureRandom.hex(8)}"
          end

          @@charges[charge_id] = charge
          charge
        end

        def retrieve_charge(charge_id, template: "charge_paid.json")
          charge = @@charges[charge_id]

          if charge
            # Merge with paid template to get complete paid charge response
            paid_template = load_charge_template(template)
            charge.merge!(
              "authorized" => paid_template["authorized"],
              "paid" => paid_template["paid"],
              "status" => paid_template["status"],
              "transaction" => "trxn_test_#{SecureRandom.hex(8)}"
            )
            charge
          else
            nil
          end
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
    end
  end
end