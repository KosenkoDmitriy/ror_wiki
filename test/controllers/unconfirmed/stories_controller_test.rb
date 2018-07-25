require 'test_helper'

class Unconfirmed::StoriesControllerTest < ActionDispatch::IntegrationTest #ActionController::TestCase
  test "show" do
    topic = topics(:one)
    story = stories(:one)
    sourceUrl = 'https://en.wikipedia.org/'
    story.sources << Source.create!(url: sourceUrl)
    get topic_unconfirmed_story_path topic, story
    assert_equal "show", @controller.action_name
    assert_match story.title, @response.body
    assert_match story.text, @response.body
    assert_match story.sources.first.url, @response.body
    assert_match topic.title, @response.body
  end
end
