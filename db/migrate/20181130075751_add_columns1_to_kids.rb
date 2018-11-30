class AddColumns1ToKids < ActiveRecord::Migration[5.2]
  def change
    add_column :kids, :ic_1, :string
    add_column :kids, :ic_2, :string
    add_column :kids, :ic_3, :string
    add_column :kids, :dob, :date
    add_column :kids, :birth_place, :string
    add_column :kids, :arr_infam, :string
    add_column :kids, :allergy, :string
    add_column :kids, :fav_food, :string
    add_column :kids, :hobby, :string
    add_column :kids, :panel_clinic, :string
    add_column :kids, :mother_name, :string
    add_column :kids, :mother_phone, :string
    add_column :kids, :mother_job, :string
    add_column :kids, :mother_job_address, :string
    add_column :kids, :father_name, :string
    add_column :kids, :father_phone, :string
    add_column :kids, :father_job, :string
    add_column :kids, :father_job_address, :string
    add_column :kids, :income, :string
    add_column :kids, :alt_phone, :string
  end
end
