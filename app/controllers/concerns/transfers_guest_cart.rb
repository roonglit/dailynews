module TransfersGuestCart
  extend ActiveSupport::Concern

  private

  def transfer_guest_cart_to_member(member)
    return unless session[:guest_user_id].present?

    guest = Guest.find_by(id: session[:guest_user_id])
    return unless guest

    # Transfer cart items to member
    member.merge_cart_from_guest(guest)

    # Reload guest's cart to clear cached cart_item association
    # This prevents cascade deletion of the transferred cart_item
    guest.cart&.reload

    # Now safe to destroy guest and its cart
    guest.destroy
    session.delete(:guest_user_id)
  end
end
