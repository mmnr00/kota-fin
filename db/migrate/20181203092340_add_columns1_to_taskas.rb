class AddColumns1ToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :phone_1, :string
    add_column :taskas, :phone_2, :string
    add_column :taskas, :address_1, :string
    add_column :taskas, :address_2, :string
    add_column :taskas, :city, :string
    add_column :taskas, :states, :string
    add_column :taskas, :postcode, :string
    add_column :taskas, :supervisor, :string
    add_column :taskas, :bank_name, :string
    add_column :taskas, :acc_no, :string
    add_column :taskas, :acc_name, :string
    add_column :taskas, :ssm_no, :string
    add_column :taskas, :collection_id, :string
  end
end
