class Tchdetail < ApplicationRecord
	belongs_to :teacher
	has_many :fotos
end
