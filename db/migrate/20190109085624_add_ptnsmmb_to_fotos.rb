class AddPtnsmmbToFotos < ActiveRecord::Migration[5.2]
  def change
    add_column :fotos, :ptns_mmb_id, :integer
  end
end
