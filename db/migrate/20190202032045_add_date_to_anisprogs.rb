class AddDateToAnisprogs < ActiveRecord::Migration[5.2]
  def change
    add_column :anisprogs, :start, :time
    add_column :anisprogs, :end, :time
  end
end
