class CheckoutsController < ApplicationController
  def show
    @order = Order.new
    @product = current_user.cart&.cart_item&.product
    @cart_item = current_user.cart&.cart_item
  end

  def create
  end
end
