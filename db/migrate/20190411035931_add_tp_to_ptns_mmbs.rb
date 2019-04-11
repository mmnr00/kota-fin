class AddTpToPtnsMmbs < ActiveRecord::Migration[5.2]
  def change
    add_column :ptns_mmbs, :tp, :string
  end
end
