class CreateTchdetailColleges < ActiveRecord::Migration[5.2]
  def change
    create_table :tchdetail_colleges do |t|
      t.integer :tchdetail_id
      t.integer :college_id

      t.timestamps
    end
  end
end
