class Course < ApplicationRecord
	belongs_to :college, optional: true
	has_many :payments
	has_many :teacher_courses
	has_many :teachers, through: :teacher_courses
	has_many :fotos
	accepts_nested_attributes_for :fotos
end
