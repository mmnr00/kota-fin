class CreatePslexes < ActiveRecord::Migration[5.2]
  def change
    create_table :pslexes do |t|
      t.string :name
      t.float :amt
      t.integer :taska_id

      t.timestamps
    end
  end
end
