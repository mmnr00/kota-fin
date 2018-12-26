class AddExtraToKidBills < ActiveRecord::Migration[5.2]
  def change
    add_column :kid_bills, :extra, :text
  end
end
