class Taska < ApplicationRecord
	has_many :taska_admins
	has_many :admins, through: :taska_admins
	has_many :expenses
	has_many :teachers
end
