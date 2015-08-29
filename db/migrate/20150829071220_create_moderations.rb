class CreateModerations < ActiveRecord::Migration
  def change
    create_table :moderations do |t|
      t.string :title
      t.text :text
      t.text :stext
      t.boolean :is_approved

      t.timestamps null: false
    end
  end
end
