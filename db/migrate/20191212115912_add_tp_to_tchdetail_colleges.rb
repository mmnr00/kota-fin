class AddTpToTchdetailColleges < ActiveRecord::Migration[5.2]
  def change
    add_column :tchdetail_colleges, :tp, :string
  end
end
