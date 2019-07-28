class AddSecphToKids < ActiveRecord::Migration[5.2]
  def change
    add_column :kids, :sph_1, :string
    add_column :kids, :sph_2, :string
  end
end
