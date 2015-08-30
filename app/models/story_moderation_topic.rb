class StoryModerationTopic < ActiveRecord::Base
  belongs_to :moderation
  belongs_to :topic
end
