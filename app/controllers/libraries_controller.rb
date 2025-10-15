class LibrariesController < ApplicationController
  before_action :authenticate_user!, only: %i[ show ]

  def show
    @newspapers = []

    if current_user.memberships.blank?
      redirect_to root_path
      return
    end

    current_user.memberships.each do |membership|
      newspapers = Newspaper.where("published_at >= ? and published_at <= ?", membership.start_date, membership.end_date).order_by_created_at
      @newspapers += newspapers
    end

    @newspapers = @newspapers.uniq
  end
end
