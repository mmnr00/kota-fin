class CreateSiblings < ActiveRecord::Migration[5.2]
  def change
    create_table :siblings do |t|
    	t.belongs_to :kid
    	t.belongs_to :beradik, class:'Kid'
      t.timestamps
    end
  end
end
