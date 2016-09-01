class CreateHarvests < ActiveRecord::Migration[5.0]
  def change
    create_table :harvests do |t|
      t.string :name

      t.timestamps
    end
  end
end
