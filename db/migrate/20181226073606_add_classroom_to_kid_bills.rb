class AddClassroomToKidBills < ActiveRecord::Migration[5.2]
  def change
    add_column :kid_bills, :classroom_id, :integer
  end
end
