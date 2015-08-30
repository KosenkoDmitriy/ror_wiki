class StoryModeration < ActiveRecord::Base
  belongs_to :story
  belongs_to :moderation

end
