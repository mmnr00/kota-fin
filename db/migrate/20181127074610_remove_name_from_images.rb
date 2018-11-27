class RemoveNameFromImages < ActiveRecord::Migration[5.2]
  def change
    remove_column :images, :name, :string
  end
end
