class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.string :text
      t.text :url
      t.text :path
      t.text :alt

      t.timestamps null: false
    end
  end
end
