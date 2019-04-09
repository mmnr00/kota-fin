class AddCltid2ToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :collection_id2, :string
  end
end
