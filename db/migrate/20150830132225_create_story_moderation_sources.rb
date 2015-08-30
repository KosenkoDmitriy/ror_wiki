class CreateStoryModerationSources < ActiveRecord::Migration
  def change
    create_table :story_moderation_sources do |t|
      t.belongs_to :moderation, index:true
      t.belongs_to :source, index:true

      t.timestamps null: false
    end
  end
end
