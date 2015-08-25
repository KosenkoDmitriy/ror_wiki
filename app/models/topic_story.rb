class TopicStory < ActiveRecord::Base
  belongs_to :topic
  belongs_to :story
end
