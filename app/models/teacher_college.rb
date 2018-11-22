class TeacherCollege < ApplicationRecord
	belongs_to :teacher 
	belongs_to :college
end
