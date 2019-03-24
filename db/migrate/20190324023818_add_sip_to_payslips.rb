class AddSipToPayslips < ActiveRecord::Migration[5.2]
  def change
    add_column :payslips, :sip, :float
    add_column :payslips, :sipa, :float
  end
end
