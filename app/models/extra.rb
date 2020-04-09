class Extra < ApplicationRecord
	belongs_to :taska, optional: true
	belongs_to :classroom, optional: true

	#old kidcare
	has_many :kid_extras
	has_many :kids, through: :kid_extras
	before_save :save_extras

	protected

  def save_extras
  	self.name = self.name.upcase
  end
end
