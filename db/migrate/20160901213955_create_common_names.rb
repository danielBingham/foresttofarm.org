class CreateCommonNames < ActiveRecord::Migration[5.0]
  def change
    create_table :common_names do |t|
      t.string :name
      t.references :plant, foreign_key: true

      t.timestamps
    end
  end
end
