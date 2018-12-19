class Sibling < ApplicationRecord
	belongs_to :kid
	belongs_to :beradik, :class_name => 'Kid'
end
