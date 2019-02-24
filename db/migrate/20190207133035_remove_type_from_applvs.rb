class RemoveTypeFromApplvs < ActiveRecord::Migration[5.2]
  def change
    remove_column :applvs, :type, :string
  end
end
