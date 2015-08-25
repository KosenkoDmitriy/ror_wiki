class Topic < ActiveRecord::Base
  has_many :topic_story
  has_many :stories, through: :topic_story
end
