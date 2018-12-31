class Expense < ApplicationRecord
	belongs_to :taska
	has_many :fotos
	accepts_nested_attributes_for :fotos

	def self.search(param_1, param_2, param_3)
		to_send_back = expenses_matches(param_1, param_2, param_3)
		return nil unless to_send_back
		to_send_back
	end

	def self.expenses_matches(param_1, param_2, param_3)
		matches('month', param_1, 'year', param_2, 'taska_id', param_3)
	end

	

	def self.matches(field_name1, param_1, field_name2, param_2, field_name3, param_3)
    	where("#{field_name1}='#{param_1}' AND #{field_name2}='#{param_2}' AND #{field_name3}='#{param_3}'")

  	end

end
