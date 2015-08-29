class Story < ActiveRecord::Base
  has_many :topic_story
  has_many :topics, through: :topic_story

  has_many :story_source
  has_many :sources, through: :story_source

  has_many :story_moderation
  has_many :moderations, through: :story_moderation

  #has_one :moderations, through: :story_moderation, :source => :story

end
