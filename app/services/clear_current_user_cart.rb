class ClearCurrentUserCart
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def perform
    cart = user.cart
    return true unless cart # No cart to clear

    cart.cart_item&.destroy
    cart.destroy
    true
  rescue => e
    Rails.logger.error("Failed to clear cart for user #{user.id}: #{e.message}")
    false
  end
end
