class CreateStoryModerationTopics < ActiveRecord::Migration
  def change
    create_table :story_moderation_topics do |t|
      t.belongs_to :moderation, index:true
      t.belongs_to :topic, index:true

      t.timestamps null: false
    end
  end
end
