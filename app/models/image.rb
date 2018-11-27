class Image < ApplicationRecord
	belongs_to :course, optional: true
	mount_uploader :picture, PictureUploader
end
