class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :title
      t.text :text
      t.string :stext
      t.string :text
      t.boolean :is_approved

      t.timestamps null: false
    end
  end
end
