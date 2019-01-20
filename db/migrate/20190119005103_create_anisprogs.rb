class CreateAnisprogs < ActiveRecord::Migration[5.2]
  def change
    create_table :anisprogs do |t|
      t.string :name
      t.string :lec

      t.timestamps
    end
  end
end
