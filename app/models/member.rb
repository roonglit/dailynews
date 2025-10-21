class Member < User
  # Members have full authentication and can purchase memberships

  def guest?
    false
  end

  def member?
    true
  end

  def name
    email
  end

  def merge_cart_from_guest(guest)
    guest_cart = guest.cart
    return if guest_cart&.cart_item.blank?

    user_cart = Cart.find_or_create_by(user_id: id)
    user_cart.cart_item&.destroy

    user_cart.create_cart_item!(product_id: guest_cart.cart_item.product_id)
  end
end
