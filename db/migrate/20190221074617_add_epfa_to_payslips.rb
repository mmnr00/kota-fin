class AddEpfaToPayslips < ActiveRecord::Migration[5.2]
  def change
    add_column :payslips, :epfa, :float
    add_column :payslips, :amtepfa, :float
  end
end
