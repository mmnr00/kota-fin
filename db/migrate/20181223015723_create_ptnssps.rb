class CreatePtnssps < ActiveRecord::Migration[5.2]
  def change
    create_table :ptnssps do |t|
      t.string :name
      t.string :strgh
      t.string :wkns
      t.string :opp
      t.string :thr

      t.timestamps
    end
  end
end
