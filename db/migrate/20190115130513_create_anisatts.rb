class CreateAnisatts < ActiveRecord::Migration[5.2]
  def change
    create_table :anisatts do |t|
      t.integer :course_id
      t.integer :tchdetail_id
      t.boolean :att

      t.timestamps
    end
  end
end
