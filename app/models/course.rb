class Course < ApplicationRecord
	belongs_to :college, optional: true
	has_many :payments
	has_many :teacher_courses
	has_many :teachers, through: :teacher_courses
	has_many :fotos
	has_many :anisatts
	has_many :anisprogs
	has_many :tchdetails, through: :anisatts
	has_many :anisfeeds
	has_many :feedbacks
	accepts_nested_attributes_for :fotos
end
