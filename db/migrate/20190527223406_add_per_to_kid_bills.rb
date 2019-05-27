class AddPerToKidBills < ActiveRecord::Migration[5.2]
  def change
    add_column :kid_bills, :kidname, :string
    add_column :kid_bills, :kidic, :string
  end
end
