require 'test_helper'

class CartsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get shopping_carts_show_url
    assert_response :success
  end

end
