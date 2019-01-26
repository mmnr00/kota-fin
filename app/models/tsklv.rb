class Tsklv < ApplicationRecord
	belongs_to :taska, optional: true
	has_many :tchlvs
end
