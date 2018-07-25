require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  test "should get title with date" do
    date_time = DateTime.now
    title = "Topic Title 1"
    topic = Topic.create(title: title, date_time: date_time)
    assert_equal "#{topic.title} (#{date_time.utc.to_formatted_s(:db)} UTC)", topic.title_with_date
  end
end
