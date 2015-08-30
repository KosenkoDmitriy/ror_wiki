class StoryModerationSource < ActiveRecord::Base
  belongs_to :moderation
  belongs_to :source
end
