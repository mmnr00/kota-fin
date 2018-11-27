class AddImgnameToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :img_name, :string
  end
end
