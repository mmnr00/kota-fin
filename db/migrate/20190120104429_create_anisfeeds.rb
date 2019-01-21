class CreateAnisfeeds < ActiveRecord::Migration[5.2]
  def change
    create_table :anisfeeds do |t|
      t.integer :rate
      t.string :bad
      t.string :good
      t.integer :course_id
      t.integer :tchdetail_id

      t.timestamps
    end
  end
end
