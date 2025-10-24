class OrdersController < ApplicationController
  before_action :set_order, only: %i[ verify complete ]

  # POST /orders or /orders.json
  def create
    @order = current_user.orders.create(order_params)

    if @order.valid?
      # first step, we will be using omise token for creating a charge
      charge = Omise::Charge.create({
        amount: (order_params[:total_cents].to_i),
        currency: "thb",
        return_uri: verify_order_url(@order),
        card: order_params[:token]
      })

      @order.update charge_id: charge.id
      redirect_to charge.authorize_uri, allow_other_host: true
    else
      p @order.errors.full_messages
    end

    # @cart = current_user.cart
    # @product = @cart&.product

    # unless @product
    #   redirect_to root_path, alert: "No product in cart" and return
    # end

    # @order = current_user.orders.build(order_params)
    # @order.sub_total = Money.new(@product.amount * 100, "THB")
    # @order.total = @order.sub_total

    # respond_to do |format|
    #   if process_order
    #     format.html { redirect_to complete_order_path(@order), notice: "Order was successfully created." }
    #     format.json { render :show, status: :created, location: @order }
    #   elseb
    #     format.html { redirect_to checkout_path, alert: @order.errors.full_messages.join(", "), status: :unprocessable_entity }
    #     format.json { render json: @order.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def verify
    charge = Omise::Charge.retrieve(@order.charge_id)

    if charge.paid
      @order.paid!
      redirect_to complete_order_path(@order)
    else
      p "order not paid!"
      # redirect to order page
    end
  end

  def complete
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.expect(order: [ :token, :total_cents ])
    end

    def process_order
      Order.transaction do
        # Create order item linking order to product
        @order.build_order_item(product: @product)

        # Check if this is a test order or paid order
        if @order.token == "testing_only"
          # Skip payment processing for testing
          unless @order.save
            raise ActiveRecord::Rollback
          end
        else
          # TODO: Process payment with Omise using @order.token
          # For now, just save the order
          unless @order.save
            raise ActiveRecord::Rollback
          end
        end

        # Create membership after successful order
        creator = MembershipCreator.new(@order)
        unless creator.call
          @order.errors.add(:base, "Failed to create membership")
          raise ActiveRecord::Rollback
        end

        # Clear the cart
        @cart.cart_item&.destroy
        @cart.destroy

        true
      end
    end

    def required_order
      redirect_to root_path if current_user&.orders.blank? || !current_user.orders.exists?(id: params[:id])
    end
end
