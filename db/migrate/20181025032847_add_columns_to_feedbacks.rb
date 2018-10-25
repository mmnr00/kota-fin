class AddColumnsToFeedbacks < ActiveRecord::Migration[5.2]
  def change
    add_column :feedbacks, :taska_id, :integer
    add_column :feedbacks, :classroom_id, :integer
  end
end
