class LibrariesController < ApplicationController
  def show
    @newspapers = Newspaper.where("published_at >= ?", current_user.memberships.last.start_date).order_by_created_at if current_user.memberships.last.end_date >= Date.today
  end
end
