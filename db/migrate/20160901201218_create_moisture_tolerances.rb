class CreateMoistureTolerances < ActiveRecord::Migration[5.0]
  def change
    create_table :moisture_tolerances do |t|
      t.string :name

      t.timestamps
    end
  end
end
