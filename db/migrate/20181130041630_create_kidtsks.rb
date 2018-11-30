class CreateKidtsks < ActiveRecord::Migration[5.2]
  def change
    create_table :kidtsks do |t|
      t.integer :kid_id
      t.integer :taska_id

      t.timestamps
    end
  end
end
