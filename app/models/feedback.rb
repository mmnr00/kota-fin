class Feedback < ApplicationRecord
	belongs_to :classroom, optional: true
	belongs_to :taska, optional: true
	belongs_to :anisprog, optional: true
	belongs_to :course, optional: true
	belongs_to :anisfeed, optional: true
	

end
