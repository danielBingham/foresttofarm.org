class CreateLightTolerances < ActiveRecord::Migration[5.0]
  def change
    create_table :light_tolerances do |t|
      t.string :name

      t.timestamps
    end
  end
end
