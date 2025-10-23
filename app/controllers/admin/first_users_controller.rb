module Admin
  class FirstUsersController < ApplicationController
    before_action :require_authentication
    skip_before_action :require_authentication, unless: -> { AdminUser.exists? }

    def new
      @admin_user = AdminUser.new
    end

    def create
      @admin_user = AdminUser.new(admin_user_params)

      if @admin_user.save
        flash[:notice] = "Admin account created successfully."
        redirect_to admin_root_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def require_authentication
      redirect_to new_admin_user_session_path, alert: "Admin already exists. Please sign in." unless user_signed_in?
    end

    def admin_user_params
      params.require(:admin_user).permit(:email, :password, :password_confirmation)
    end
  end

end