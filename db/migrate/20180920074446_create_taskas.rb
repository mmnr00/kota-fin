class CreateTaskas < ActiveRecord::Migration[5.2]
  def change
    create_table :taskas do |t|

      t.timestamps
    end
  end
end
