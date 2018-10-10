class Classroom < ApplicationRecord
	belongs_to :taska
	has_many :teachers_classrooms
	has_many :teachers, through: :teachers_classrooms
	has_many :kids
	
	
end
