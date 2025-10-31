class LibrariesController < ApplicationController
  before_action :authenticate_member!, only: %i[ show ]
  before_action :required_subscription

  def show
    @newspapers = []

    @months = current_user.subscriptions.map do |subscription|
      (subscription.start_date..subscription.end_date).map { |day| day.strftime("%m") }
    end.flatten.uniq.sort

    conditions = current_user.subscriptions.map do |subscription|
      "(published_at >= '#{subscription.start_date}' and published_at <= '#{subscription.end_date}')"
    end

    @newspapers = Newspaper.where(conditions).filter_by_month(params[:month]).order_by_created_at.distinct
  end

  def required_subscription
    redirect_to root_path, alert: t("alerts.messages.require_subscription") if current_user.subscriptions.blank?
  end
end
