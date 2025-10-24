module Admin
  class CustomersController < BaseController
    before_action :set_member, only: %i[show edit update]

    def index
      @members = Member.all.order(:id)
    end

    def show
      @memberships = @member&.memberships.order(id: :desc)
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
