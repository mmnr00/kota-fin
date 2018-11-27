class CreateTchdetails < ActiveRecord::Migration[5.2]
  def change
    create_table :tchdetails do |t|
      t.string :name
      t.string :ic_1
      t.string :ic_2
      t.string :ic_3
      t.string :phone_1
      t.string :phone_2

      t.timestamps
    end
  end
end
