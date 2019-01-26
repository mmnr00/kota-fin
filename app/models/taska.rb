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
	has_many :extras
	has_many :tsklvs
	has_many :tchlvs
	before_save :save_taskas
	accepts_nested_attributes_for :fotos
	include HTTParty


	private

	def save_taskas
		self.address_1 = self.address_1.upcase
		self.address_2 = self.address_2.upcase
		self.city = self.city.upcase
		self.states = self.states.upcase
		self.supervisor = self.supervisor.upcase
		self.acc_name = self.acc_name.upcase
		self.ssm_no = self.ssm_no.upcase
		self.name = self.name.upcase
	end
	


end
