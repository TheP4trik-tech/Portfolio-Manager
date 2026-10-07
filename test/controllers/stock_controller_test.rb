require "test_helper"

class StockControllerTest < ActionDispatch::IntegrationTest
  test "should get snapshots" do
    get stock_snapshots_url
    assert_response :success
  end
end
