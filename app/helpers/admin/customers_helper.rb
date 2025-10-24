module Admin::CustomersHelper
  def full_name(first_name, last_name)
    return "-" if first_name.blank? && last_name.blank?
    "#{first_name} #{last_name}"
  end
end
