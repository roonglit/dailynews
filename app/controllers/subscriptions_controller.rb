class SubscriptionsController < AccountSettingController
  before_action :set_subscription, only: %i[index update]
  before_action :authenticate_member!, only: %i[ index ]

  def index
    @subscription = current_user.subscriptions.last
  end

  def update
    respond_to do |format|
      if @subscription.update(subscription_params)
        format.html { redirect_to subscriptions_path, notice: "Auto renew updated successfully." }
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
