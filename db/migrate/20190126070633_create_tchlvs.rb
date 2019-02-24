class CreateTchlvs < ActiveRecord::Migration[5.2]
  def change
    create_table :tchlvs do |t|
      t.string :name
      t.float :day

      t.timestamps
    end
  end
end
