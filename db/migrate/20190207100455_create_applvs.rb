class CreateApplvs < ActiveRecord::Migration[5.2]
  def change
    create_table :applvs do |t|
      t.integer :teacher_id
      t.integer :taska_id
      t.date :start
      t.date :end
      t.string :type
      t.string :tchdesc
      t.string :tskdesc
      t.string :stat

      t.timestamps
    end
  end
end
