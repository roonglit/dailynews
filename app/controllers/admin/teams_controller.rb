module Admin
  class TeamsController < BaseController
    def index
      @admins = Admin::User.all.order(id: :asc)
    end

    def new
    end

    def create
    end
  end
end
