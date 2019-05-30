class AddFxddcToPayinfos < ActiveRecord::Migration[5.2]
  def change
    add_column :payinfos, :fxddc, :float
  end
end
