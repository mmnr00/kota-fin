class CreatePslextches < ActiveRecord::Migration[5.2]
  def change
    create_table :pslextches do |t|
      t.integer :teacher_id
      t.integer :pslex_id

      t.timestamps
    end
  end
end
