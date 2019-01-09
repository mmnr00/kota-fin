class AddEmailToPtnsMmbs < ActiveRecord::Migration[5.2]
  def change
    add_column :ptns_mmbs, :email, :string
  end
end
