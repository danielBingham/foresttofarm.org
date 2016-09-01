class CreateDrawbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :drawbacks do |t|
      t.string :name

      t.timestamps
    end
  end
end
