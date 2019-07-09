class AddPslblToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :pslm, :integer
    add_column :taskas, :blgt, :boolean
  end
end
