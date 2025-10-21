class Guest < User
  # Guests don't need email/password validation
  # They can browse and add items to cart

  def guest?
    true
  end

  def member?
    false
  end

  def name
    "Guest"
  end

  # Convert guest to member with email and password
  def convert_to_member!(email:, password:, password_confirmation:)
    self.type = "Member"
    self.email = email
    self.password = password
    self.password_confirmation = password_confirmation
    save!
  end
end
