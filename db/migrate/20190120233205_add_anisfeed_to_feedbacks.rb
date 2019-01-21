class AddAnisfeedToFeedbacks < ActiveRecord::Migration[5.2]
  def change
    add_column :feedbacks, :anisfeed_id, :integer
  end
end
