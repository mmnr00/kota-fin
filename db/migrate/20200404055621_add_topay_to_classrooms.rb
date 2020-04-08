class AddTopayToClassrooms < ActiveRecord::Migration[5.2]
  def change
    add_column :classrooms, :topay, :string
  end
end
