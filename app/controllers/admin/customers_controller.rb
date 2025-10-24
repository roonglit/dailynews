module Admin
  class CustomersController < BaseController
    before_action :set_member, only: %i[show edit update]

    def index
      @members = Member.all
    end

    def show
      @memberhips = current_user&.memberships&.order_by_created_at
    end

    def edit
    end

    def update
    end
  end

  private

  def set_member
    @member = Member.find(params.expect(:id))
  end
end
