class Anisprog < ApplicationRecord
	belongs_to :course
	has_many :feedbacks
	has_many :anisatts
end
