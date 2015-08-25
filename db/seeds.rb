# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


topics_count = 20
stories_count = 20
(1..topics_count).to_a.each do |topic_no|
  topic = Topic.find_or_create_by!(title:"Topic #{topic_no}")
  (1..stories_count).to_a.each do |story_no|
    title = "Story # #{story_no} of the Topic # #{topic_no}"
    text = title + " description " * 59
    stext = text.truncate(25, omission: '... (continued)')
    story = Story.find_or_create_by!(title: title, text:text, stext:stext, is_approved:true)
    topic.stories << story if story.present? && topic.present?
  end
  topic.save
end