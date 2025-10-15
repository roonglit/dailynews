class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  def complete
    @order = Order.find(params[:id])
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @cart = current_user.cart
    @product = @cart&.product

    unless @product
      redirect_to new_membership_path, alert: "No product in cart" and return
    end

    @order = current_user.orders.build(order_params)
    @order.sub_total = Money.new(@product.amount * 100, "THB")
    @order.total = @order.sub_total

    respond_to do |format|
      if process_order
        format.html { redirect_to complete_order_path(@order), notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { redirect_to checkout_path, alert: @order.errors.full_messages.join(", "), status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: "Order was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to orders_path, notice: "Order was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.expect(order: [ :token ])
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
end
