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
end
