class AddExtToClassrooms < ActiveRecord::Migration[5.2]
  def change
    add_column :classrooms, :ext_o, :integer
    add_column :classrooms, :ext_t, :integer
  end
end
