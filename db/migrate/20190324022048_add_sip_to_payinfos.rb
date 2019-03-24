class AddSipToPayinfos < ActiveRecord::Migration[5.2]
  def change
    add_column :payinfos, :sip, :float
    add_column :payinfos, :sipa, :float
  end
end
