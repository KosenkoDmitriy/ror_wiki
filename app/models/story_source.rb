class StorySource < ActiveRecord::Base
  belongs_to :story
  belongs_to :source
end
