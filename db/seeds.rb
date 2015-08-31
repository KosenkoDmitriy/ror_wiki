# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# works even with basic ruby
def random_time from = Time.at(0.0), to = Time.now
  rand(from..to)
end

# works only with rails. syntax is quite similar to time method above :)
def random_date from = Date.new(1970), to = Time.now.to_date
  rand(from..to)
end

def random_date_time
  date_time = DateTime.new(rand(1970..2015), rand(1..12), rand(1..28), rand(1..24), rand(1..60), rand(1..60))
  return date_time
end

def random_approved_status
  [true, false].sample
end

topics_count = 20
stories_count = 20
moderation_count = 20
(1..topics_count).to_a.each do |topic_no|

  topic = Topic.find_or_create_by!(title:"Topic #{topic_no}")
  topic.date_time = random_date_time()
  topic.is_approved = random_approved_status()
  puts "-"*100
  puts "topic: #{topic}\n"
  (1..stories_count).to_a.each do |story_no|
    title = "Story # #{story_no} of the Topic # #{topic_no}"
    text = title + " description " * 59
    stext = text.truncate(50, omission: '...')
    story = Story.find_or_create_by!(title: title, text:text, stext:stext)
    story.is_approved = random_approved_status()
    story.save
    if story.present?
      puts "+story: #{story.try(:title)}"

      (1..moderation_count).to_a.each do |moderation_no|
        title = "Moderation Story # #{story_no} of the Topic # #{topic_no}"
        text = title + " description " * 59
        stext = text.truncate(50, omission: '...')
        moderation = Moderation.find_or_create_by!(title: title, text:text, stext:stext)
        moderation.is_approved = random_approved_status()
        moderation.topics << topic if !story.topics.exists?(topics: {id:topic.id})
        puts "++mstory: #{moderation.try(:title)}"
        puts "+++mtopic: #{topic.try(:title)}"
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
          puts "+++msource: #{source.try(:title)} #{source.try(:url)}"
          moderation.sources << source if !story.sources.exists?(sources: {id:source.id})
        end

        moderation.save
        story.moderations << moderation
      end

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