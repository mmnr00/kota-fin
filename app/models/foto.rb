class Foto < ApplicationRecord
	belongs_to :course, optional: true
	belongs_to :tchdetail, optional: true
	mount_uploader :picture, PictureUploader
end
