class Classroom < ApplicationRecord
	
	belongs_to :taska
	has_many :extras
	has_many :vhcls
	has_many :payments
	serialize :vehls,Hash

	# OLD KIDCARE
	has_many :teachers_classrooms
	has_many :teachers, through: :teachers_classrooms
	has_many :kids
	has_many :feedbacks
	has_many :kid_bills
	has_many :payments, through: :kid_bills
	
	

	private

	def save_classrooms
		self.classroom_name = self.classroom_name.upcase
	end
	
end
