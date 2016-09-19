class UpdateImages < ActiveRecord::Migration[5.0]
  def up 
    create_table :images do |t|
      t.integer :height
      t.integer :width
      t.string  :attribution
      t.string  :extension
      t.references :plant
    end
  end

  def down
    drop_table :images
  end
end
