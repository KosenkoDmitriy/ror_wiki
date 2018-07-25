class StoriesHelperTest < ActionView::TestCase
  test "should get stext by default" do
    stext_before = "default value"
    stext_after = stext_or_text "default value", nil, 0
    assert_equal stext_before, stext_after
  end
  test "should cut text up to 5 or 150 symbols and add omission at the end ('...')" do
    temp = stext_or_text nil, stories(:one).text, 5
    assert_equal temp.length, 5
    text = stories(:one).text
    temp = stext_or_text nil, text, nil
    assert_equal temp.length, 150
  end
end
