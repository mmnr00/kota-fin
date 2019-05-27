class KidBill < ApplicationRecord
	belongs_to :kid 
	belongs_to :payment
	belongs_to :classroom, optional: true
	serialize :extra,Array
	serialize :extradtl,Hash
end
