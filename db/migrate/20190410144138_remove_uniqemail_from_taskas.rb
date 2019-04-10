class RemoveUniqemailFromTaskas < ActiveRecord::Migration[5.2]
  def change
    remove_index :taskas, column: :email, unique: true
  end
end
