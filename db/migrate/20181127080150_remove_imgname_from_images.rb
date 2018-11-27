class RemoveImgnameFromImages < ActiveRecord::Migration[5.2]
  def change
    remove_column :images, :img_name, :string
  end
end
