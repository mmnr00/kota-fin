class Kid < ApplicationRecord
	belongs_to :parent
	#belongs_to :classroom, optional: true
	has_many :payments
	has_many :taska_admins
	has_many :admins, through: :taska_admins
	belongs_to  :taska, optional: true
	belongs_to  :classroom, optional: true
	has_many :fotos
	accepts_nested_attributes_for :fotos

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
end
