class CreateColleges < ActiveRecord::Migration[5.2]
  def change
    create_table :colleges do |t|
      t.string :name
      t.string :address
      t.string :collection_id

      t.timestamps
    end
    add_index :colleges, :name, unique: true
    add_index :colleges, :collection_id, unique: true
  end
end
