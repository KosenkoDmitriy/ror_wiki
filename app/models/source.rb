class Source < ActiveRecord::Base
  belongs_to :story
  def title_and_url
    "#{title}: #{url}"
  end
end
