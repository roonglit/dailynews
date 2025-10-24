module Admin
  class SubscriptionsController < BaseController
    def show
      @members = Member.all.order(:id)
    end
  end
end
