class Taska < ApplicationRecord
	has_many :taska_admins
	has_many :admins, through: :taska_admins
	has_many :expenses
	has_many :payments
	has_many :taska_teachers
	has_many :teachers, through: :taska_teachers
	has_many :classrooms
	has_many :feedbacks


end
