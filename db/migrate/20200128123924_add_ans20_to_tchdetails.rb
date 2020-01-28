class AddAns20ToTchdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :tchdetails, :aku, :string
    add_column :tchdetails, :ts_tp, :string
    add_column :tchdetails, :biloku, :string
  end
end
