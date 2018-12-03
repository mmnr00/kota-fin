class AddPlanToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :plan, :string
  end
end
