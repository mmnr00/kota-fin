class AddBookingToTaskas < ActiveRecord::Migration[5.2]
  def change
    add_column :taskas, :booking, :float
  end
end
