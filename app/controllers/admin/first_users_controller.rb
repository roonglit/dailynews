module Admin
  class FirstUsersController < ApplicationController
    before_action :require_admin_exists

    def new
      email = request.query_parameters[:mail].presence || params[:mail].presence

      @admin_user = Admin::User.new(email: email)
    end

    def create
      @admin_user = Admin::User.new(admin_user_params)

      if @admin_user.save
        flash[:notice] = "Admin account created successfully."
        redirect_to admin_root_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def require_admin_exists
      redirect_to admin_root_path if Admin::User.exists?
    end

    def admin_user_params
      params.require(:admin_user).permit(:email, :password, :password_confirmation)
    end
  end
end
