module Admin
  class SubscriptionsController < BaseController
    def show
      @members = Member.all
    end
  end
end
