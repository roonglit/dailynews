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
        @invitation = Admin::Invitation.new
      end

      def update
        @invitation = Admin::Invitation.new(invitation_params)
        @invitation.invited_by = current_admin_user

        if @invitation.email.blank?
          @all_admins = Admin::User.search(params[:q]).order(:id)
          items_per_page = params[:per_page].to_i
          items_per_page = 10 unless items_per_page.positive?
          page = params[:page].present? && params[:page].to_i > 0 ? params[:page].to_i : 1
          @pagy, @admins = pagy(@all_admins, limit: items_per_page, page: page, params: { q: params[:q], per_page: params[:per_page] }.compact)
          flash.now[:alert] = "Email can't be blank"
          render :show
          return
        end

        service = Admin::InvitationService.new(invited_by: current_admin_user)
        result = service.create_invitation(email: @invitation.email)

        if result[:success]
          redirect_to admin_settings_team_path, notice: "Invitation sent successfully."
        else
          @all_admins = Admin::User.search(params[:q]).order(:id)
          items_per_page = params[:per_page].to_i
          items_per_page = 10 unless items_per_page.positive?
          page = params[:page].present? && params[:page].to_i > 0 ? params[:page].to_i : 1
          @pagy, @admins = pagy(@all_admins, limit: items_per_page, page: page, params: { q: params[:q], per_page: params[:per_page] }.compact)
          flash.now[:alert] = result[:error]
          render :show
        end
      end

      private

      def invitation_params
        params.require(:admin_invitation).permit(:email)
      end
    end
  end
end
