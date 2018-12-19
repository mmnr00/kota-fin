class CreateKidBills < ActiveRecord::Migration[5.2]
  def change
    create_table :kid_bills do |t|
      t.integer :kid_id
      t.integer :payment_id

      t.timestamps
    end
  end
end
