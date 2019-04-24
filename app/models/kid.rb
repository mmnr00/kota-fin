class Kid < ApplicationRecord
	belongs_to :parent
	#belongs_to :classroom, optional: true
	has_many :taska_admins
	has_many :admins, through: :taska_admins
	belongs_to  :taska, optional: true
	belongs_to  :classroom, optional: true
	has_many :fotos
	accepts_nested_attributes_for :fotos
	before_save :save_kids
	has_many :siblings
	has_many :beradik, through: :siblings
	has_many :kid_bills
	has_many :payments, through: :kid_bills
	has_many :kid_extras
	has_many :extras, through: :kid_extras
	has_many :otkids
	include HTTParty


	#validates_uniqueness_of :name, :case_sensitive => false

	def self.search(param_1, param_2)
		parent = Parent.where("'email' = 'param_2'")
		param_2 = parent.id
		to_send_back = kids_matches(param_1, param_2)
		return nil unless to_send_back.parent.email = param_2
		to_send_back
	end

	def self.kids_matches(param_1, param_2)
		matches('name', param_1, 'email', param_2)
	end

	

	def self.matches(field_name1, param_1, field_name2, param_2)
    	where("#{field_name1}='#{param_1}'")

  end

  protected

  def save_kids
  	self.name = self.name.upcase unless !self.name.present?
  	self.birth_place = self.birth_place.upcase unless !self.birth_place.present?
  	self.allergy = self.allergy.upcase unless !self.allergy.present?
  	self.fav_food = self.fav_food.upcase unless !self.fav_food.present?
  	self.hobby = self.hobby.upcase unless !self.hobby.present?
  	self.panel_clinic = self.panel_clinic.upcase unless !self.panel_clinic.present?
  	self.mother_name = self.mother_name.upcase unless !self.mother_name.present?
  	self.mother_job = self.mother_job.upcase unless !self.mother_job.present?
  	self.mother_job_address = self.mother_job_address.upcase unless !self.mother_job_address.present?
  	self.father_name = self.father_name.upcase unless !self.father_name.present?
  	self.father_job = self.father_job.upcase unless !self.father_job.present?
  	self.father_job_address = self.father_job_address.upcase unless !self.father_job_address.present?
  end

end

















