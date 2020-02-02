class AddThmToColleges < ActiveRecord::Migration[5.2]
  def change
    add_column :colleges, :thm, :string
  end
end
