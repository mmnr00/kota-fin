class CreateKids < ActiveRecord::Migration[5.2]
  def change
    create_table :kids do |t|
      t.string :name
      t.integer :parent_id
      t.integer :classroom_id

      t.timestamps
    end
  end
end
