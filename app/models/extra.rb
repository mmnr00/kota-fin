class Extra < ApplicationRecord
	belongs_to :taska, optional: true
	has_many :kid_extras
	has_many :kids, through: :kid_extras
	before_save :save_extras

	protected

  def save_extras
  	self.name = self.name.upcase
  end
end
