class Taska < ApplicationRecord
	has_many :taska_admins
	has_many :admins, through: :taska_admins
end
