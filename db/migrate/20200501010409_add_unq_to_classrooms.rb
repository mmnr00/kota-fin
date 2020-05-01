class AddUnqToClassrooms < ActiveRecord::Migration[5.2]
  def change
    add_column :classrooms, :unq, :string
  end
end
