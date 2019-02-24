class CreateTsklvs < ActiveRecord::Migration[5.2]
  def change
    create_table :tsklvs do |t|
      t.string :name
      t.string :desc
      t.integer :day
      t.integer :taska_id

      t.timestamps
    end
  end
end
