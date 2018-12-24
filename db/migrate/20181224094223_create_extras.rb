class CreateExtras < ActiveRecord::Migration[5.2]
  def change
    create_table :extras do |t|
      t.string :name
      t.float :price
      t.integer :taska_id

      t.timestamps
    end
  end
end
