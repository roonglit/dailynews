require 'rails_helper'

RSpec.describe "Admin::Widgets", type: :request do
  # Note: These tests verify that routes exist and controllers are set up correctly.
  # Admin routes require authentication, so they return 302 redirects when not authenticated.
  # TODO: Add authentication setup (e.g., sign_in helper) for more comprehensive testing

  describe "GET /admin/widgets/revenue" do
    it "route exists and controller responds" do
      get revenue_admin_widgets_path
      # Expect redirect to login (302) since authentication is required
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET /admin/widgets/active_subscriptions" do
    it "route exists and controller responds" do
      get active_subscriptions_admin_widgets_path
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET /admin/widgets/customers" do
    it "route exists and controller responds" do
      get customers_admin_widgets_path
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET /admin/widgets/new_subscriptions" do
    it "route exists and controller responds" do
      get new_subscriptions_admin_widgets_path
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET /admin/widgets/revenue_chart" do
    it "route exists and controller responds" do
      get revenue_chart_admin_widgets_path
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET /admin/widgets/customers_chart" do
    it "route exists and controller responds" do
      get customers_chart_admin_widgets_path
      expect(response).to have_http_status(:redirect)
    end
  end
end
