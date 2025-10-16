module CheckoutHelper
  def user_already_login?(user)
    !(user.nil? || user.guest?)
  end
end
