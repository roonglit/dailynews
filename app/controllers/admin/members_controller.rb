module Admin
  class MembersController < BaseController
    before_action :set_member, only: %i[ edit update ]

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

      membership = @member.memberships.new(start_date: params[:start_date], end_date: params[:end_date])
      if membership.save
        redirect_to admin_members_path, notice: "Membership created"
      else
        redirect_to admin_members_path, alert: "Membership cannot be created"
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @member = Member.find(params.expect(:id))
      end
  end
end
