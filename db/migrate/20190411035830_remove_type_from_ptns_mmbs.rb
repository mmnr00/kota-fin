class RemoveTypeFromPtnsMmbs < ActiveRecord::Migration[5.2]
  def change
    remove_column :ptns_mmbs, :type, :string
  end
end
