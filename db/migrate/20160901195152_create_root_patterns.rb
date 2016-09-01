class CreateRootPatterns < ActiveRecord::Migration[5.0]
  def change
    create_table :root_patterns do |t|
      t.string :name
      t.string :symbol
      t.string :description

      t.timestamps
    end
  end
end
