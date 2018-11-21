class Payment < ApplicationRecord
	belongs_to :kid, optional: true
	belongs_to :parent, optional: true
	belongs_to :taska, optional: true
	belongs_to :teacher, optional: true
	belongs_to :course, optional: true
	include HTTParty

	


end
