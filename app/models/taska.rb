class Taska < ApplicationRecord
	has_many :taska_admins
	has_many :admins, through: :taska_admins
	has_many :expenses
	has_many :payments
	has_many :taska_teachers
	has_many :teachers, through: :taska_teachers
	has_many :classrooms
	has_many :feedbacks
	has_many :kids
	has_many :fotos
	accepts_nested_attributes_for :fotos
	include HTTParty
	


end
