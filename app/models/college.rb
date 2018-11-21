class College < ApplicationRecord
	has_many :owner_colleges
	has_many :owners, through: :owner_colleges
	has_many :courses
end
