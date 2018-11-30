class Foto < ApplicationRecord
	belongs_to :course, optional: true
	belongs_to :tchdetail, optional: true
	belongs_to :kid, optional: true
	mount_uploader :picture, PictureUploader
end
