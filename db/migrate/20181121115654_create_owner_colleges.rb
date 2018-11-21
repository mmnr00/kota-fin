class CreateOwnerColleges < ActiveRecord::Migration[5.2]
  def change
    create_table :owner_colleges do |t|
      t.integer :owner_id
      t.integer :college_id

      t.timestamps
    end
  end
end
