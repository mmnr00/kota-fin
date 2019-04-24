class CreateOtkids < ActiveRecord::Migration[5.2]
  def change
    create_table :otkids do |t|
      t.integer :kid_id
      t.integer :payment_id
      t.float :amt

      t.timestamps
    end
  end
end
