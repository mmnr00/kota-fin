class AddEpfaToPayinfos < ActiveRecord::Migration[5.2]
  def change
    add_column :payinfos, :epfa, :float
  end
end
