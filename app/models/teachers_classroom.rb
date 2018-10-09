class TeachersClassroom < ApplicationRecord
	belongs_to :classroom
	belongs_to :teacher
 
end
