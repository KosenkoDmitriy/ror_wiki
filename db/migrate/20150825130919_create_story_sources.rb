class CreateStorySources < ActiveRecord::Migration
  def change
    create_table :story_sources do |t|
      t.belongs_to :story, index:true
      t.belongs_to :source, index:true

      t.timestamps null: false
    end
  end
end
