class AddDateTimeToStoriesAndModerations < ActiveRecord::Migration
  def change
    add_column :stories, :date_time, :datetime
    add_column :moderations, :date_time, :datetime
  end
end
