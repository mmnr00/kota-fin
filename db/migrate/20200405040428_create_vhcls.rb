class CreateVhcls < ActiveRecord::Migration[5.2]
  def change
    create_table :vhcls do |t|
      t.string :plt
      t.string :brnd
      t.string :typ
      t.string :classroom_id

      t.timestamps
    end
  end
end
