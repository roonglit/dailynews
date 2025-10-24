class CheckoutsController < ApplicationController
  def show
    if member_signed_in?
      p "<<<< Member Signed In >>>>"
    else
      p "<<<< Member Not Signed In >>>>"
      session[:member_return_to] = request.fullpath
    end

    @cart = current_user&.cart
    @cart_item = @cart&.cart_item
    @product = @cart_item&.product
  end

  # def create
  # end
end
