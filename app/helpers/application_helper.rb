module ApplicationHelper
  def duration(start_date, end_date)
    return "-" if start_date.blank?
    if start_date.year != end_date.year
      "#{start_date.day} #{start_date.strftime('%b %Y')} - #{end_date.day} #{end_date.strftime('%b %Y')}"
    elsif start_date.month == end_date.month
      if start_date.day == end_date.day
        "#{start_date.day} #{start_date.strftime('%b %Y')}"
      else
        "#{start_date.day}-#{end_date.day} #{start_date.strftime('%b %Y')}"
      end
    else
      "#{start_date.day} #{start_date.strftime('%b')} - #{end_date.day} #{end_date.strftime('%b %Y')}"
    end
  end
end
