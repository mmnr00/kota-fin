class CreateFotos < ActiveRecord::Migration[5.2]
  def change
    create_table :fotos do |t|
      t.string :picture
      t.integer :course_id

      t.timestamps
    end
  end
end
