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

  setup do
    @topic = topics(:one)
    @story = stories(:one)
  end

  test "should get index" do
    story2 = stories(:two)
    @topic.stories << @story
    @topic.stories << story2
    get topic_stories_path(@topic)
    assert_equal @topic.stories.count, 2
    assert_response :success
  end

  test "should get show" do
    get topic_story_path(@topic, @story)
    assert_response :success
    assert_select 'h1', @story.title
    get topic_story_path(@topic, -1)
    assert_response :missing
    get topic_story_path(-1, @story)
    assert_response :success
    get topic_story_path(-1, -1)
    assert_response :missing
  end

  test "should create a new unconfirmed story" do
    get new_topic_story_path(@topic)
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

    # get "/topics/#{topic.id}/stories/new?orig_story_id=#{story.id}"
    # assert_response :redirect
    # follow_redirect!
    get "/topics/#{@topic.id}/unconfirmed/stories/new?orig_story_id=#{@story.id}"
    assert_response :success
    assert_select 'h1', 'Create New Story'
    assert_select 'p.topic', @topic.title
    assert_select 'input[value=?]', @story.title
  end

  test "should append new stories after click on button 'load more'" do
    topic = Topic.create!(title: "Topic 1", is_approved: true)
    (1..40).each do |no|
      story = Story.create!(title: "Story #{no}", is_approved: true)
      topic.stories << story
    end
    topic.save
    topic.reload
    assert_equal topic.stories.count, 40
    get '/'
    assert_select 'h1', 'Homepage'
    # assert_select '.container p', 'No any stories found'
    assert_select ".timeline-title", 20

    # TODO click on "load more" button
    assert_select "a.form-control"
    assert_select ".timeline-title", 40
  end
end
