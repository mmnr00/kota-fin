class Tchdetail < ApplicationRecord
	belongs_to :teacher, optional: true
	has_many :fotos
	has_many :tchdetail_colleges
	has_many :colleges, through: :tchdetail_colleges
	has_many :anisatts
	has_many :courses, through: :anisatts
	has_many :anisfeeds
	accepts_nested_attributes_for :fotos
end
