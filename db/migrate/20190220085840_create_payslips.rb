class CreatePayslips < ActiveRecord::Migration[5.2]
  def change
    create_table :payslips do |t|
      t.integer :mth
      t.integer :year
      t.float :amt
      t.float :alwnc
      t.float :epf
      t.float :addtn
      t.string :desc
      t.integer :teacher_id
      t.integer :taska_id

      t.timestamps
    end
  end
end
