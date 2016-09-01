class CreatePlants < ActiveRecord::Migration[5.0]
  def change
    create_table :plants do |t|
      t.string :genus
      t.string :species
      t.string :family
      t.float :minimum_PH
      t.float :maximum_PH
      t.float :minimum_height
      t.float :maximum_height
      t.float :minimum_width
      t.float :maximum_width
      t.string :minimum_zone
      t.string :maximum_zone
      t.string :growth_rate
      t.string :native_region

      t.timestamps
    end
  end
end
