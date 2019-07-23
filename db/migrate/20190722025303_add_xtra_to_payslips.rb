class AddXtraToPayslips < ActiveRecord::Migration[5.2]
  def change
    add_column :payslips, :xtra, :text
  end
end
