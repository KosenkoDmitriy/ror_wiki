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
  puts "-"*100
  puts "topic: #{topic}\n"
  (1..stories_count).to_a.each do |story_no|
    title = "Story # #{story_no} of the Topic # #{topic_no}"
    text = title + " description " * 59
    stext = text.truncate(50, omission: '...')
    story = Story.find_or_create_by!(title: title, text:text, stext:stext, is_approved:true)
    if story.present?
      puts "+story: #{story.try(:title)}"
      sources = [{url:"https://en.wikipedia.org/wiki/Barack_Obama", title:"Wikipedia"},
                     {url:"https://www.facebook.com/barackobama", title:"Facebook"},
                     {url:"https://twitter.com/barackobama?lang=ru", title:"Twitter"},
                     {url: "https://plus.google.com/+BarackObama", title:"Google+"},
                     {url:"https://www.linkedin.com/in/barackobama", title:"Linkedin"}
      ]
      sources.each do |source|
        url = source[:url]
        title = source[:title]
        # source_title = "Source of the story #{story.try(:title)}"
        source = Source.find_or_create_by!(title:title, url:url) # added sources to the story
        puts "++source: #{source.try(:title)} #{source.try(:url)}"
        story.sources << source if !story.sources.exists?(sources: {id:source.id})
      end
      # story.sources = story.sources.uniq #now work
      story.save
      topic.stories << story if topic.present? && !topic.stories.exists?(stories: {id:story.id}) # added stories in the topic
    end
  end
  # topic.stories = topic.stories.uniq #now work
  topic.save
  end
User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')