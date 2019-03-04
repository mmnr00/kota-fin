class AddNewToPayslips < ActiveRecord::Migration[5.2]
  def change
    add_column :payslips, :socs, :float
    add_column :payslips, :socsa, :float
    add_column :payslips, :dedc, :float
    add_column :payslips, :descdc, :string
  end
end
