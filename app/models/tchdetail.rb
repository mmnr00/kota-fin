class Tchdetail < ApplicationRecord
	belongs_to :teacher, optional: true
	has_many :fotos
	accepts_nested_attributes_for :fotos
end
