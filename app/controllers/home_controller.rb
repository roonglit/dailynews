class HomeController < ApplicationController
  def index
    @newspapers = Newspaper.all
    @monthly_product = Product.find_by(sku: "MEMBERSHIP_MONTHLY_SUBSCRIPTION")
    @latest_newspaper = Newspaper.where.not(published_at: nil).order(published_at: :desc).first
  end
end
