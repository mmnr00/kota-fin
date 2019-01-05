class CreatePtnsMmbs < ActiveRecord::Migration[5.2]
  def change
    create_table :ptns_mmbs do |t|
      t.string :name

      t.timestamps
    end
  end
end
