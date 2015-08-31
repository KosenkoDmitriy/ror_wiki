class AddDateTimeToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :date_time, :datetime
  end
end
