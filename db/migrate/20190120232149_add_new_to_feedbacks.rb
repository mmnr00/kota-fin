class AddNewToFeedbacks < ActiveRecord::Migration[5.2]
  def change
    add_column :feedbacks, :course_id, :integer
    add_column :feedbacks, :anisprog_id, :integer
  end
end
