class SubscriptionsController < AccountSettingController
  before_action :set_membership, only: %i[index update]

  def index
  end

  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to subscriptions_path, notice: "Auto renew updated successfully." }
      end
    end
  end

  private

  def set_membership
    @membership = current_user.memberships.last
  end

  def membership_params
    params.expect(membership: [ :auto_renew ])
  end
end
