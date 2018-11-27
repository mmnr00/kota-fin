class Foto < ApplicationRecord
	belongs_to :courses, optional: true
	mount_uploader :picture, PictureUploader
end
