class Moderation < ActiveRecord::Base
  has_one :story_moderation
  has_one :story, through: :story_moderation

  has_many :story_source
  has_many :sources, through: :story_source

  # has_many :topic_story
  # has_many :topics, through: :topic_story
end
