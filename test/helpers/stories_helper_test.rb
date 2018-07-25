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
  test "should group by date_time" do
    storyList = Story.order(date_time: :desc, title: :asc)
    itemsDT = group_by_date_time storyList
    # assert_equal itemsDT, {date_time: DateTime.now.strftime("%b %Y"), items: []}
    assert_equal itemsDT[0][:items][0][:dt_full], storyList.first.date_time.strftime("%d %B %H:%M")
    assert_equal itemsDT[0][:items][1][:dt_full], storyList.second.date_time.strftime("%d %B %H:%M")
    assert_equal itemsDT[0][:date_time], DateTime.now.strftime("%b %Y")
  end
end
