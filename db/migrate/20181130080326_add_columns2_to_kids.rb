class AddColumns2ToKids < ActiveRecord::Migration[5.2]
  def change
    add_column :kids, :date_enter, :date
  end
end
