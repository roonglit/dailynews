module Admin
  class TeamsController < BaseController
    include Pagy::Backend

    def index
      items_per_page = params[:per_page].to_i
      items_per_page = 10 unless items_per_page.positive?
      page = params[:page].present? && params[:page].to_i > 0 ? params[:page].to_i : 1
      @all_admins = Admin::User.search(params[:q]).order(:id)
      @pagy, @admins = pagy(@all_admins, limit: items_per_page, page: page, params: { q: params[:q], per_page: params[:per_page] }.compact)
    end

    def new
    end

    def create
    end

    def invite
      email = params[:invite][:email]

      if email.blank?
        redirect_to new_admin_team_path, alert: "Email can't be blank"
        return
      end

      service = InvitationService.new(invited_by: current_admin_user)
      result = service.create_invitation(email: email)

      if result[:success]
        redirect_to new_admin_team_path, notice: "Invitation sent successfully."
      else
        redirect_to new_admin_team_path, alert: result[:error]
      end
    end

    def destroy
      @admin_user = Admin::User.find(params.expect(:id))
      @admin_user.destroy!

      respond_to do |format|
        format.html { redirect_to admin_teams_path, notice: "Product was successfully destroyed.", status: :see_other }
        format.json { head :no_content }
      end
    end
  end
end
