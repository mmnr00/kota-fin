class AddUnconfirmedToTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :unconfirmed_email, :string
  end
end
