class Foto < ApplicationRecord
	belongs_to :course, optional: true
	belongs_to :tchdetail, optional: true
	belongs_to :kid, optional: true
	belongs_to :taska, optional: true
	belongs_to :expense, optional: true
	belongs_to :ptns_mmb, optional: true
	belongs_to :applv, optional: true
	belongs_to :payment, optional: true
	belongs_to :parpaym, optional: true
	mount_uploader :picture, PictureUploader
end
