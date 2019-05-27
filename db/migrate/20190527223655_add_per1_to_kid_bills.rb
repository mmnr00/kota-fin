class AddPer1ToKidBills < ActiveRecord::Migration[5.2]
  def change
    add_column :kid_bills, :clsname, :string
    add_column :kid_bills, :clsfee, :float
    add_column :kid_bills, :extradtl, :text
  end
end
