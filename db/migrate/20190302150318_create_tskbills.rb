class CreateTskbills < ActiveRecord::Migration[5.2]
  def change
    create_table :tskbills do |t|
      t.float :real
      t.float :disc
      t.integer :payment_id

      t.timestamps
    end
  end
end
