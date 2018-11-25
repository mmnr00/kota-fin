class AddConfirmableToTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :confirmation_token, :string
    add_column :teachers, :confirmed_at, :datetime
    add_column :teachers, :confirmation_sent_at, :datetime
  end
end
