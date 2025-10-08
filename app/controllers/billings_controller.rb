class BillingsController < SettingsController
  def index
    @memberships = current_user.memberships
  end
end
