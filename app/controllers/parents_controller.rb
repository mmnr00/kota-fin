class ParentsController < ApplicationController
	before_action :authenticate_parent!
	before_action :set_parent, only: [:index,:view_bill]
	def index
		@parent = current_parent
		@mykids = @parent.kids.order('updated_at DESC')
	end

	def view_bill
		@mykids = @parent.kids
	end

	def individual_bill
		@kid = Kid.find(params[:kid])
		@kid_bills = @kid.payments.where(bill_month: params[:month], bill_year: params[:year]) 
	end


	private

	def set_parent
		@parent = Parent.find(current_parent.id)
	end
end