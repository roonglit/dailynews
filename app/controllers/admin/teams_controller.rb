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
      return redirect_to new_admin_team_path, notice: "Email can't be blank" if params[:invite][:email].blank?

      Admin::UserMailer.invite_admin(params[:invite][:email]).deliver_now
      redirect_to new_admin_team_path, notice: "Invitation sent successfully."
    end
  end
end
