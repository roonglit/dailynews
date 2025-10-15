class LibrariesController < ApplicationController
  before_action :authenticate_member!, only: %i[ show ]

  def show
    @newspapers = []

    current_user.memberships.each do |membership|
      newspapers = Newspaper.where("published_at >= ? and published_at <= ?", membership.start_date, membership.end_date).order_by_created_at
      @newspapers += newspapers
    end

    @newspapers = @newspapers.uniq
  end
end
