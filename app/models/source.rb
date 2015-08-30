class Source < ActiveRecord::Base
  belongs_to :story
  belongs_to :moderation
  def title_and_url
    "#{title}: #{url}"
  end
end
