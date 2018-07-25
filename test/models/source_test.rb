require 'test_helper'

class SourceTest < ActiveSupport::TestCase
  test "should get title and url" do
    source = Source.create(title: 'Facebook', url: 'http://facebook.com/12313113')
    assert_equal "#{source.title}: #{source.url}", source.title_and_url
  end
end
