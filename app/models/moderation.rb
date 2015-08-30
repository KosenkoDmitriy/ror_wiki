class Moderation < ActiveRecord::Base
  has_one :story_moderation
  has_one :story, through: :story_moderation
  #accepts_nested_attributes_for :story, allow_destroy: true

  #has_many :story_source
  #has_many :sources, through: :story_source

  has_many :story_moderation_source
  has_many :sources, through: :story_moderation_source
  accepts_nested_attributes_for :sources, allow_destroy: true

  has_many :story_moderation_topic
  has_many :topics, through: :story_moderation_topic
  accepts_nested_attributes_for :topics, allow_destroy: true

  # has_many :topic_story
  # has_many :topics, through: :topic_story
end
