class College < ApplicationRecord
	has_many :owner_colleges
	has_many :owners, through: :owner_colleges
	has_many :courses
	has_many :teacher_colleges
	has_many :teachers, through: :teacher_colleges
	has_many :tchdetail_colleges
	has_many :tchdetails, through: :tchdetail_colleges
end
