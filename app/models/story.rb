class Story < ActiveRecord::Base
  has_many :topic_story
  has_many :topics, through: :topic_story
end
