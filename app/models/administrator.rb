class Administrator < User
  # Administrators have full authentication and can access to manage user membership, product and newspaper

  def guest?
    false
  end

  def member?
    false
  end

  def administrator?
    true
  end

  def name
    "[ADMIN]: " + email
  end
end
