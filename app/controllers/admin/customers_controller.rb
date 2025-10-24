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
    end

  private

    def set_member
      @member = Member.find(params.expect(:id))
    end
  end
end
