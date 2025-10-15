class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  include Pundit::Authorization
  allow_browser versions: :modern
  helper_method :current_user, :user_signed_in?
  before_action :current_or_guest_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to new_membership_path
    end

    # Override Devise's current_user to include guest users
    def current_user
      @current_user ||= begin
        if warden.authenticate?(scope: :member)
          warden.user(:member)
        else
          current_guest_user
        end
      end
    end

    def current_guest_user
      # Return existing guest from session if it exists
      if session[:guest_user_id]
        guest = Guest.find_by(id: session[:guest_user_id])
        return guest if guest
      end

      # Create a new guest user and store in session
      guest = Guest.create!
      session[:guest_user_id] = guest.id
      guest
    end

    def current_or_guest_user
      # This ensures guest is created on every request if not signed in
      current_user
    end

    def user_signed_in?
      warden.authenticated?(:member)
    end
end
