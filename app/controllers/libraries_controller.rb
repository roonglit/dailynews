class LibrariesController < ApplicationController
  before_action :authenticate_member!, only: %i[ show ]

  def show
    @newspapers = []

    @months = current_user.memberships.map do |membership|
      (membership.start_date..membership.end_date).map { |day| day.strftime("%m") }
    end.flatten.uniq.sort

    conditions = current_user.memberships.map do |membership|
      "(published_at >= '#{membership.start_date}' and published_at <= '#{membership.end_date}')"
    end

    @newspapers = Newspaper.where(conditions).filter_by_month(params[:month]).order_by_created_at.distinct
  end
end
