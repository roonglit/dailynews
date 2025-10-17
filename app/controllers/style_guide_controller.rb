class StyleGuideController < ApplicationController
  # Only allow access in development and staging environments
  before_action :check_environment

  def index
    # This view serves as a living style guide for developers
  end

  private

  def check_environment
    unless Rails.env.development? || Rails.env.staging?
      redirect_to root_path, alert: "Style guide is only available in development and staging environments"
    end
  end
end
