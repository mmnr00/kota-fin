class AddTpToExtras < ActiveRecord::Migration[5.2]
  def change
    add_column :extras, :tp, :string
  end
end
