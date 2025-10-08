require "test_helper"

class BillingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @memberships = memberships(:one)
  end

  test "should get index" do
    get memberships_url
    assert_response :success
  end
end
