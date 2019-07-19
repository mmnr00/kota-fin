class Pslex < ApplicationRecord
	belongs_to :taska
	has_many :pslextchs
	has_many :teachers, through: :pslextchs
end
