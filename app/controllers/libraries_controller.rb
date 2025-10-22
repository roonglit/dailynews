class LibrariesController < ApplicationController
  before_action :authenticate_member!, only: %i[ show ]

  def show
    @newspapers = []

    @months = current_user.memberships.map do |membership|
      (membership.start_date..membership.end_date).map { |day| day.strftime("%m") }
    end.flatten.uniq.sort

    current_user.memberships.each do |membership|
      newspapers = Newspaper.where("published_at >= ? and published_at <= ?", membership.start_date, membership.end_date)
      .filter_by_month(params[:month])
      .order_by_created_at
      @newspapers += newspapers
    end

    @newspapers = @newspapers.uniq
  end
end
