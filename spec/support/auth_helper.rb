module AuthHelper
  def login_auth
    user = create(:user)
    login_as(user, scope: :user)
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :system
end
