module Admin
  class CustomersController < BaseController
    include Pagy::Backend
    before_action :set_member, only: %i[show edit update]

    def index
      items_per_page = params[:per_page].to_i
      items_per_page = 10 unless items_per_page.positive?
      page = params[:page].present? && params[:page].to_i > 0 ? params[:page].to_i : 1
      members = Member.search(params[:q]).order(:id)
      @pagy, @members = pagy(members, limit: items_per_page, page: page, params: { q: params[:q], per_page: params[:per_page] }.compact)
    end

    def show
      @subscriptions = @member&.subscriptions.order(id: :desc)
      @orders = @member&.orders.order(created_at: :desc)
    end

    def edit
    end

    def update
      respond_to do |format|
        if @member.update(member_params)
          ExtractCoverJob.perform_later @member.id
          format.html { redirect_to admin_customer_path(@member), notice: "Member was successfully updated.", status: :see_other }
          format.json { render :show, status: :ok, location: @member }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @member.errors, status: :unprocessable_entity }
        end
      end
    end

  private

    def set_member
      @member = Member.find(params.expect(:id))
    end

    def member_params
      params.expect(member: [ :id, :first_name, :last_name ])
    end
  end
end
