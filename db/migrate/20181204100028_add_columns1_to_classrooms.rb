class AddColumns1ToClassrooms < ActiveRecord::Migration[5.2]
  def change
    add_column :classrooms, :description, :string
    add_column :classrooms, :base_fee, :float
  end
end
