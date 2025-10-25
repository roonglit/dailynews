module Admin
  class MembersController < BaseController
    before_action :set_user, only: %i[ edit update ]

    # GET /admin/members or /admin/members.json
    def index
      @members = Member.all
    end

    # GET /admin/members/1/edit
    def edit
    end

    # PATCH/PUT /admin/members/1 or /admin/members/1.json
    def update
      if params[:start_date].blank? || params[:end_date].blank?
        redirect_to edit_admin_members_path, alert: "Start date and End date can't be blank"
        return
      end

      subscription = @member.subscriptions.new(start_date: params[:start_date], end_date: params[:end_date])
      if subscription.save
        redirect_to admin_members_path, notice: "Subscription created"
      else
        redirect_to admin_members_path, alert: "Subscription cannot be created"
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @member = Member.find(params.expect(:id))
      end
  end
end
