module NewspapersHelper
  def check_newspaper_memberships(newspaper, user)
    user&.memberships&.where("start_date >= ? and end_date >= ?", newspaper.created_at.to_date, Date.today).present?
  end
end
