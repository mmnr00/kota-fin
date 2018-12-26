class Classroom < ApplicationRecord
	belongs_to :taska
	has_many :teachers_classrooms
	has_many :teachers, through: :teachers_classrooms
	has_many :kids
	has_many :feedbacks
	has_many :kid_bills
	has_many :payments, through: :kid_bills
	
	
end
