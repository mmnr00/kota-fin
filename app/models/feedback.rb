class Feedback < ApplicationRecord
	belongs_to :classroom, optional: true
	belongs_to :taska, optional: true
	

end
