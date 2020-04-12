class Payment < ApplicationRecord
	belongs_to :parent, optional: true
	belongs_to :taska, optional: true
	belongs_to :teacher, optional: true
	belongs_to :classroom, optional: true
	has_one :kid_bill, dependent: :destroy

	#OLD
	belongs_to :course, optional: true
	
	#has_many :kids, through: :kid_bills
	has_many :addtns, dependent: :destroy
	has_one :tskbill
	has_many :fotos
	has_many :parpayms
	has_many :otkids, dependent: :destroy
	accepts_nested_attributes_for :addtns
	accepts_nested_attributes_for :fotos
	include HTTParty

	


end
