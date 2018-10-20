class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.integer :collection_id
      t.string :name

      t.timestamps
    end
  end
end
