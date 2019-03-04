class AddSocsToPayinfos < ActiveRecord::Migration[5.2]
  def change
    add_column :payinfos, :socs, :float
    add_column :payinfos, :socsa, :float
  end
end
