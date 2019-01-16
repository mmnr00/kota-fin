class AddColums1ToPtnsMmbs < ActiveRecord::Migration[5.2]
  def change
    add_column :ptns_mmbs, :expire, :date
    add_column :ptns_mmbs, :mmbid, :string
  end
end
