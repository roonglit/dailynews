# frozen_string_literal: true

class Members::SessionsController < Devise::SessionsController
  include TransfersGuestCart

  # POST /members/sign_in
  def create
    super do |member|
      # Transfer guest cart to member after successful sign-in
      transfer_guest_cart_to_member(member) if member.persisted?
    end
  end
end
