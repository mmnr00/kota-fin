class Expense < ApplicationRecord
	belongs_to :taska

	def self.search(param_1, param_2)
		to_send_back = expenses_matches(param_1, param_2)
		return nil unless to_send_back
		to_send_back
	end

	def self.expenses_matches(param_1, param_2)
		matches('month', param_1, 'year', param_2)
	end

	

	def self.matches(field_name1, param_1, field_name2, param_2)
    	where("#{field_name1}='#{param_1}' AND #{field_name2}='#{param_2}'")

  	end

end
