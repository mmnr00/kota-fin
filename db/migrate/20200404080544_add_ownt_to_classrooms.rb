class AddOwntToClassrooms < ActiveRecord::Migration[5.2]
  def change
    add_column :classrooms, :own_name, :string
    add_column :classrooms, :own_dob, :date
    add_column :classrooms, :own_ph, :string
    add_column :classrooms, :own_email, :string
    add_column :classrooms, :tn_name, :string
    add_column :classrooms, :tn_dob, :date
    add_column :classrooms, :tn_ph, :string
    add_column :classrooms, :tn_email, :string
  end
end
