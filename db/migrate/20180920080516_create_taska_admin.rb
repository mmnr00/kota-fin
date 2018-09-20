class CreateTaskaAdmin < ActiveRecord::Migration[5.2]
  def change
    create_table :taska_admins do |t|
    	t.integer :taska_id 
    	t.integer :admin_id
    end
  end
end
