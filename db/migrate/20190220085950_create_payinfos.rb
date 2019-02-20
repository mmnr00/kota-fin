class CreatePayinfos < ActiveRecord::Migration[5.2]
  def change
    create_table :payinfos do |t|
      t.float :amt
      t.float :alwnc
      t.float :epf
      t.integer :teacher_id
      t.integer :taska_id

      t.timestamps
    end
  end
end
