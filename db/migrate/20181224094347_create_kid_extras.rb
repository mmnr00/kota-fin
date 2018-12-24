class CreateKidExtras < ActiveRecord::Migration[5.2]
  def change
    create_table :kid_extras do |t|
      t.integer :kid_id
      t.integer :extra_id

      t.timestamps
    end
  end
end
