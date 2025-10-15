module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[ edit update ]

    # GET /admin/users or /admin/users.json
    def index
      @users = User.all
    end

    # GET /admin/users/1/edit
    def edit
    end

    # PATCH/PUT /admin/users/1 or /admin/users/1.json
    def update
      membership = @user.memberships.new(start_date: params[:start_date], end_date: params[:end_date])
      if membership.save
        redirect_to admin_users_path, notice: "Membership created"
      else
        redirect_to admin_users_path, alert: "Membership cannot be created"
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def user_params
        params.fetch(:user, {})
      end
  end
end
