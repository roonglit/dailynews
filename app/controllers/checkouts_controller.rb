class CheckoutsController < ApplicationController
  def show
    @cart = current_user&.cart
    @cart_item = @cart&.cart_item
    @product = @cart_item&.product

    if member_signed_in?
      p "<<<< Member Signed In >>>>"
    else
      p "<<<< Member Not Signed In >>>>"
      p request.fullpath
      session[:member_return_to] = request.fullpath
    end
  end

  # def create
  # end
end
