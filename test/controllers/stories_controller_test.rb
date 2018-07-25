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
  test "should get show" do
    topic = topics(:one)
    story = stories(:one)
    get topic_story_path(topic, story)
    assert_response :success
    assert_select 'h1', story.title
    # TODO can't find a tag
    # assert_select "p.autor" do |link|
    #   assert_equal link.text(), topic.title
    # end
    # assert_select 'a[href=?]', topic_path(topic), {text: topic.title}
    # assert_select 'p.autor.line a[href=?]', topic_path(topic), {text: topic.title}
    # assert_select 'a.topic_title', topic.title
    # topic_blank = Topic.new id: -1
    # story_blank = Story.new id: -1
    get topic_story_path(topic, -1)
    assert_response :missing
    get topic_story_path(-1, story)
    assert_response :success
    get topic_story_path(-1, -1)
    assert_response :missing
  end
  test "should create a new unconfirmed story" do
    topic = topics(:one)
    get new_topic_story_path(topic)
    assert_response :redirect
    # assert_redirected_to(controller: "stories", action: "new")
    # assert_redirected_to(controller: "unconfirmed_stories", action: "new")
    follow_redirect!
    # get new_topic_unconfirmed_story_path(topic)
    # ?orig_story_id=
    # get_via_redirect new_topic_unconfirmed_story_path(-1)
    # assert_response :redirect
    assert_response :success
    assert_select 'h1', 'Create New Story'
    assert_select 'input#story_title', ''
    story = stories(:one)
    topic.stories << story
    # get "/topics/#{topic.id}/stories/new?orig_story_id=#{story.id}"
    # assert_response :redirect
    # follow_redirect!
    get "/topics/#{topic.id}/unconfirmed/stories/new?orig_story_id=#{story.id}"
    assert_response :success
    assert_select 'h1', 'Create New Story'
    assert_select 'p.topic', topic.title
    assert_select 'input[value=?]', story.title
  end
end
