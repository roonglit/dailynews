class Member < User
  has_many :orders
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

    member_cart = Cart.find_or_create_by(user_id: id)
    member_cart.cart_item&.destroy

    # Transfer guest's cart_item to member's cart
    guest_cart.cart_item.update!(cart: member_cart)
  end
end
