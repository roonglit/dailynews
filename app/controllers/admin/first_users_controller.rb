module Admin
  class FirstUsersController < ApplicationController
    before_action :require_admin_exists

    def set_email
      email = decode_invite_token!(params[:token])
      session[:email] = email
      redirect_to new_admin_first_user_path(invite: "true")
    end

    def new
      email = session.delete(:email)
      @invite = params[:invite]
      @admin_user = Admin::User.new(email: email)
    end

    def create
      @admin_user = Admin::User.new(admin_user_params)

      if @admin_user.save
        flash[:notice] = "Admin account created successfully."
        redirect_to admin_root_path
      else
        redirect_to new_admin_first_user_path
      end
    end

    private

      def require_admin_exists
        redirect_to admin_root_path if Admin::User.exists?
      end

      def admin_user_params
        params.require(:admin_user).permit(:email, :password, :password_confirmation)
      end

      def decode_invite_token!(token)
        data = Rails.application.message_verifier(:user_mailer).verify(token)
        redirect_to new_admin_user_session_path if data["exp"] < Time.now
        data["email"]
      end
  end
end
