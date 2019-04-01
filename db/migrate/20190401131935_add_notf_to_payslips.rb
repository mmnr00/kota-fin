class AddNotfToPayslips < ActiveRecord::Migration[5.2]
  def change
    add_column :payslips, :notf, :integer
  end
end
