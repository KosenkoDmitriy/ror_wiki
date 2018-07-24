require 'test_helper'

class TopicsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should get index" do
    get topics_path
    assert_response :success
  end
end
