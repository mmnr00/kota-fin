class CreateAddtns < ActiveRecord::Migration[5.2]
  def change
    create_table :addtns do |t|
      t.string :desc
      t.float :amount
      t.integer :payment_id

      t.timestamps
    end
  end
end
