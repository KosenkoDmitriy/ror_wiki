class Story < ActiveRecord::Base
  has_many :topic_story
  has_many :topics, through: :topic_story
  accepts_nested_attributes_for :topics, allow_destroy: true

  has_many :story_source
  has_many :sources, through: :story_source
  accepts_nested_attributes_for :sources, allow_destroy: true
  # accepts_nested_attributes_for :sources, reject_if: :all_blank, allow_destroy: true

  has_many :story_moderation
  has_many :moderations, through: :story_moderation
  accepts_nested_attributes_for :moderations, allow_destroy: true

  #has_one :moderations, through: :story_moderation, :source => :story

end
