class KidBill < ApplicationRecord
	belongs_to :kid 
	belongs_to :payment
end
