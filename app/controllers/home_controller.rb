class HomeController < ApplicationController
  def index
    @newspapers = Newspaper.all
    @monthly_product = current_user.cart&.cart_item&.product
    @latest_newspaper = Newspaper.where.not(published_at: nil).order(published_at: :desc).first
  end
end
