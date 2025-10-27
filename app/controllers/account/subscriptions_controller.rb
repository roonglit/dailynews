class Account::SubscriptionsController < Account::BaseController
  before_action :set_subscription, only: %i[index update]

  def index
    @subscription = current_user.subscriptions.last
  end

  def update
    respond_to do |format|
      if @subscription.update(subscription_params)
        format.html { redirect_to account_subscriptions_path, notice: "Auto renew updated successfully." }
      end
    end
  end

  private

  def set_subscription
    @subscription = current_user.subscriptions.last
  end

  def subscription_params
    params.expect(subscription: [ :auto_renew ])
  end
end
