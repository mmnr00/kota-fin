class Parpaym < ApplicationRecord
	belongs_to :payment, optional: true
	has_many :fotos
	accepts_nested_attributes_for :fotos
end
