class Account::BaseController < ApplicationController
  layout "account_setting"

  before_action :authenticate_member!
end
