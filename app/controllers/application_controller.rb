class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  include Pundit
  before_action :prepare_resource

  allow_browser versions: :modern
  helper_method :current_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to new_membership_path
    end

    def prepare_resource
      @user = User.new_with_session({}, session)
    end
end
