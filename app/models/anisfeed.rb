class Anisfeed < ApplicationRecord
	belongs_to :tchdetail
	belongs_to :course
	has_many :feedbacks
	accepts_nested_attributes_for :feedbacks
end
