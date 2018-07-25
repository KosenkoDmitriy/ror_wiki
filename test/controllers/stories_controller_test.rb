require 'test_helper'

class StoriesControllerTest < ActionDispatch::IntegrationTest #ActionController::TestCase
  # TODO check ajax request using capybara
  # test "ajax request" do
  #   # get ajax_all_stories_path + '?page=2', xhr: true
  #   # get "/ajax_all_stories?page=1", xhr: true
  #   get ajax_all_stories_path, xhr: true
  #   # get "/ajax_all_stories", xhr: true, turbolinks: false
  #   # assert_equal 'hello world', @response.body
  #   # assert_equal "text/javascript", @response.content_type
  #   # assert_select ".pager .form-control", ""
  #   assert_response :success
  # end
  test "should get index" do
    topic = topics(:one)
    story = stories(:one)
    story2 = stories(:one)
    topic.stories << story
    topic.stories << story2
    get topic_stories_path(topic)
    assert_equal topic.stories.count, 2
    assert_response :success
  end
end
