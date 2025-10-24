class CheckoutsController < ApplicationController
  def show
    if member_signed_in?
      @order = Order.new(member: current_user)
    else
      session[:member_return_to] = request.fullpath
    end

    @cart = current_user&.cart
    @cart_item = @cart&.cart_item
    @product = @cart_item&.product
  end
end
