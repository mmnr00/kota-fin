class AddName1ToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :name, :string
  end
end
