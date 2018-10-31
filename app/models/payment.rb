class Payment < ApplicationRecord
	belongs_to :kid, optional: true
	belongs_to :parent, optional: true
	belongs_to :taska, optional: true
	include HTTParty

	


end
