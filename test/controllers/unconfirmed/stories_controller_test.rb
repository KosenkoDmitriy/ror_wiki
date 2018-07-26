require 'test_helper'

class Unconfirmed::StoriesControllerTest < ActionDispatch::IntegrationTest #ActionController::TestCase
  # before every single test
  setup do
    @topic = topics(:one)
    @story = stories(:one)
    @topic.stories << @story
    sourceUrl = 'https://en.wikipedia.org/'
    @story.sources << Source.create!(url: sourceUrl)
  end

  # called after every single test
  teardown do
    # when controller is using cache it may be a good idea to reset it afterwards
    Rails.cache.clear
  end

  test "should get show story" do
    get topic_unconfirmed_story_path @topic, @story
    assert_equal "show", @controller.action_name
    assert_match @story.title, @response.body
    assert_match @story.text, @response.body
    assert_match @story.sources.first.url, @response.body
    assert_equal @story.sources.count, 1
    assert_equal @story.topics.count, 1
    assert_equal @topic.stories.count, 1
    assert_match @topic.title, @response.body
  end

  test "index" do
    get topic_unconfirmed_stories_path @topic
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "should get edit page" do
    get edit_topic_unconfirmed_story_path @topic, @story
    assert_response :success
    assert_match @story.title, @response.body
    assert_match @story.text, @response.body
    assert_match @story.sources.first.url, @response.body
    assert_match @topic.title, @response.body

    assert_select "input[value=?]", @story.title
    assert_select "input[type=submit]"
  end

  test "should update story" do
    patch topic_unconfirmed_story_path @topic, @story, params: { story: {title: "updated story"}}
    assert_redirected_to topic_unconfirmed_story_path @topic, @story
    @story.reload
    assert_equal "updated story", @story.title
  end

  test "should not update story if invalid story's data" do #TODO handle exception
    patch topic_unconfirmed_story_path @topic, @story, params: { story: {title: nil, is_approved: 123}}
    assert_redirected_to topic_unconfirmed_story_path @topic, @story
    @story.reload
    assert_equal false, @story.is_approved
  end

  # test "should destroy story" do
  #   assert_difference('Story.count', -1) do
  #     delete topic_unconfirmed_story_path @topic, @story
  #   end
  #
  #   assert_redirected_to topic_unconfirmed_stories_path
  # end

  test "should create a new unconfirmed story" do
    assert_equal Story.count, 2
    article_title = 'Story New Title'
    assert_difference('Story.count') do
      post topic_unconfirmed_stories_path(@topic), params: { story: { title: article_title } }
    end
    assert_equal Story.count, 3
    story = Story.last
    # follow_redirect!
    assert_redirected_to topic_unconfirmed_story_path(@topic, story)
    assert_equal I18n.t("story.success.create"), flash[:notice]
    assert_equal story.is_approved, false
    # assert_equal story.title, article_title # TODO why story.title is nil ?
  end
end
