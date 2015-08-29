class Moderation < ActiveRecord::Base
  has_one :story_moderation
  has_one :story, through: :story_moderation

end
