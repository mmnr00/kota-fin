class AddPslidToPayslips < ActiveRecord::Migration[5.2]
  def change
    add_column :payslips, :psl_id, :string
  end
end
