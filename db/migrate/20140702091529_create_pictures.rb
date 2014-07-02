class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :name
      t.integer :height
      t.integer :width
      t.string :url

      t.timestamps
    end
  end
end
