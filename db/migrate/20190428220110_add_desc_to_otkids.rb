class AddDescToOtkids < ActiveRecord::Migration[5.2]
  def change
    add_column :otkids, :descotk, :string
  end
end
