class CheckoutsController < ApplicationController
  before_action :redirect_if_has_active_subscription
  before_action :check_member_sign_in?
  before_action :required_cart_item

  def show
    @cart = current_user&.cart
    @cart_item = @cart&.cart_item
    @product = @cart_item&.product
  end

  private

  def check_member_sign_in?
    if member_signed_in?
      @order = Order.new(member: current_user)
    else
      session[:member_return_to] = request.fullpath
    end
  end

  def required_cart_item
    redirect_to root_path if current_user.cart&.cart_item.blank?
  end

  def redirect_if_has_active_subscription
    return unless member_signed_in?

    if current_user.subscriptions.any?(&:active?)
      redirect_to library_path, notice: "You already have an active subscription. Enjoy reading!"
    end
  end
end
