require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest # ActionController::TestCase
  test "should get index" do
    get topics_url
    assert_equal "index", @controller.action_name
    get_via_redirect topics_path
    assert_response :success
    assert_select ".title-header h1", "Homepage"
    assert_select "p.text-center", "No any stories found"
  end
  test "should get show" do
    topic = topics(:one)
    get topic_url(topic)
    assert_response :success
    topic_blank = Topic.new id: -1
    get topic_path(topic_blank)
    assert_response :missing
  end
end
