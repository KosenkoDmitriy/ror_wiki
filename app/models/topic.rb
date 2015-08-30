class Topic < ActiveRecord::Base
  has_many :topic_story
  has_many :stories, through: :topic_story
  def title_with_date
    "#{title} (#{created_at})"
  end
end
