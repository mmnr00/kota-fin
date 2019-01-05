class AddColumnsToPtnsMmbs < ActiveRecord::Migration[5.2]
  def change
    add_column :ptns_mmbs, :dob, :date
    add_column :ptns_mmbs, :ic1, :string
    add_column :ptns_mmbs, :ic2, :string
    add_column :ptns_mmbs, :ic3, :string
    add_column :ptns_mmbs, :icf, :string
    add_column :ptns_mmbs, :ph1, :string
    add_column :ptns_mmbs, :ph2, :string
    add_column :ptns_mmbs, :mmb, :string
    add_column :ptns_mmbs, :edu, :string
    add_column :ptns_mmbs, :add1, :string
    add_column :ptns_mmbs, :add2, :string
    add_column :ptns_mmbs, :city, :string
    add_column :ptns_mmbs, :state, :string
    add_column :ptns_mmbs, :postcode, :string
    add_column :ptns_mmbs, :ts_name, :string
    add_column :ptns_mmbs, :ts_add1, :string
    add_column :ptns_mmbs, :ts_add2, :string
    add_column :ptns_mmbs, :ts_city, :string
    add_column :ptns_mmbs, :ts_state, :string
    add_column :ptns_mmbs, :ts_postcode, :string
    add_column :ptns_mmbs, :ts_status, :string
    add_column :ptns_mmbs, :ts_owner, :string
    add_column :ptns_mmbs, :ts_job, :string
    add_column :ptns_mmbs, :ts_ph1, :string
    add_column :ptns_mmbs, :ts_ph2, :string
  end
end
