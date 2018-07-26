require 'test_helper'

class Unconfirmed::StoriesControllerTest < ActionDispatch::IntegrationTest #ActionController::TestCase
  test "show" do
    topic = topics(:one)
    story = stories(:one)
    topic.stories << story
    sourceUrl = 'https://en.wikipedia.org/'
    story.sources << Source.create!(url: sourceUrl)
    get topic_unconfirmed_story_path topic, story
    assert_equal "show", @controller.action_name
    assert_match story.title, @response.body
    assert_match story.text, @response.body
    assert_match story.sources.first.url, @response.body
    assert_equal story.sources.count, 1
    assert_equal story.topics.count, 1
    assert_equal topic.stories.count, 1
    assert_match topic.title, @response.body
  end
  test "index" do
    topic = topics(:one)
    get topic_unconfirmed_stories_path topic
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end
  test "edit" do
    topic = topics(:one)
    story = stories(:one)
    topic.stories << story
    sourceUrl = 'https://en.wikipedia.org/'
    story.sources << Source.create!(url: sourceUrl)
    get topic_unconfirmed_story_path topic, story
    assert_response :success
    assert_match story.title, @response.body
    assert_match story.text, @response.body
    assert_match story.sources.first.url, @response.body
    assert_match topic.title, @response.body
  end
end
