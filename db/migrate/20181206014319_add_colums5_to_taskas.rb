class AddColums5ToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :bank_status, :string
    add_column :taskas, :billplz_reg, :string
  end
end
