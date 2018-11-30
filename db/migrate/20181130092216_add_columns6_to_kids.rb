class AddColumns6ToKids < ActiveRecord::Migration[5.2]
  def change
    add_column :kids, :taska_id, :integer
    add_column :kids, :classroom_id, :integer
  end
end
