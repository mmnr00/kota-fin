class OwnerCollege < ApplicationRecord
	belongs_to :owner 
	belongs_to :college
end
