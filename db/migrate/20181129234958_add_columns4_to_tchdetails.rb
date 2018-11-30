class AddColumns4ToTchdetails < ActiveRecord::Migration[5.2]
  def change
    add_column :tchdetails, :ts_name, :string
    add_column :tchdetails, :ts_address_1, :string
    add_column :tchdetails, :ts_address_2, :string
    add_column :tchdetails, :ts_city, :string
    add_column :tchdetails, :ts_states, :string
    add_column :tchdetails, :ts_postcode, :string
    add_column :tchdetails, :ts_owner_name, :string
    add_column :tchdetails, :ts_phone_1, :string
    add_column :tchdetails, :ts_phone_2, :string
  end
end
