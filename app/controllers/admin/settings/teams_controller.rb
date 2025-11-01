module Admin
  module Settings
    class TeamsController < BaseController
      include Pagy::Backend

      def show
        items_per_page = params[:per_page].to_i
        items_per_page = 10 unless items_per_page.positive?
        page = params[:page].present? && params[:page].to_i > 0 ? params[:page].to_i : 1
        @all_admins = Admin::User.search(params[:q]).order(:id)
        @pagy, @admins = pagy(@all_admins, limit: items_per_page, page: page, params: { q: params[:q], per_page: params[:per_page] }.compact)
      end

      def update
        # Handle invitation submission
        email = params[:invite][:email] if params[:invite].present?

        if email.blank?
          redirect_to admin_settings_team_path, alert: "Email can't be blank"
          return
        end

        service = InvitationService.new(invited_by: current_admin_user)
        result = service.create_invitation(email: email)

        if result[:success]
          redirect_to admin_settings_team_path, notice: "Invitation sent successfully."
        else
          redirect_to admin_settings_team_path, alert: result[:error]
        end
      end
    end
  end
end
