class CheckoutsController < ApplicationController
  before_action :required_cart, only: %i[show]

  def show
    @order = Order.new

    current_user.merge_cart_from_guest(Guest.last) if current_user.member?

    @product = current_user&.cart&.cart_item&.product
    @cart_item = current_user&.cart&.cart_item
  end

  # def create
  # end

  private

  def required_cart
    redirect_to root_path if current_user&.cart.blank?
  end
end
