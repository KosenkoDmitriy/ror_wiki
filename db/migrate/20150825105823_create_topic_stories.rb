class CreateTopicStories < ActiveRecord::Migration
  def change
    create_table :topic_stories do |t|
      t.belongs_to :topic, index: true
      t.belongs_to :story, index: true
      t.datetime :date_time
      t.timestamps null: false
    end
  end
end
