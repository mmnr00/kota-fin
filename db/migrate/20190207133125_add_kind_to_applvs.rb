class AddKindToApplvs < ActiveRecord::Migration[5.2]
  def change
    add_column :applvs, :kind, :string
  end
end
