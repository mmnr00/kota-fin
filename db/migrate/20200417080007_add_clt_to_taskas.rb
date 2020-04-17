class AddCltToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :emblz, :string
    add_column :taskas, :cltarr, :text
  end
end
