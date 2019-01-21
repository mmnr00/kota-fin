class Anisprog < ApplicationRecord
	belongs_to :course
	has_many :feedbacks
end
