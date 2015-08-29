class CreateStoryModerations < ActiveRecord::Migration
  def change
    create_table :story_moderations do |t|
      t.belongs_to :story, index:true
      t.belongs_to :moderation, index:true

      t.timestamps null: false
    end
  end
end
