class UpdateImages < ActiveRecord::Migration[5.0]
  def change
    change_table :images do |t|
      t.change  :height,  :integer
      t.change  :width,   :integer
      t.string  :attribution
      t.references :plant
    end
  end
end
