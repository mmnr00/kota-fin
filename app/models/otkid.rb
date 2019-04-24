class Otkid < ApplicationRecord
	belongs_to :kid, optional: true
	belongs_to :payment, optional: true
end
