class AddFxddcToPayslips < ActiveRecord::Migration[5.2]
  def change
    add_column :payslips, :fxddc, :float
  end
end
