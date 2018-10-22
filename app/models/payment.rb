class Payment < ApplicationRecord
	belongs_to :kid, optional: true
	include HTTParty

	


end
