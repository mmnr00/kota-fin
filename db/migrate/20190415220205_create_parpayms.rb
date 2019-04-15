class CreateParpayms < ActiveRecord::Migration[5.2]
  def change
    create_table :parpayms do |t|
      t.string :kind
      t.float :amt
      t.integer :payment_id
      t.date :upd

      t.timestamps
    end
  end
end
