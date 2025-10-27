class Account::PurchasesController < Account::BaseController
  def index
    @orders = current_user.orders.order(created_at: :desc)
  end
end
