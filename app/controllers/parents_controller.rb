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

	def pay_bill

	end

	def feedback
		f_taska = Feedback.create(rating: params[:taska_rating], 
															taska_id: params[:taska_id])
		f_classroom = Feedback.create(rating: params[:classroom_rating], 
																	classroom_id: params[:classroom_id])
		flash[:success] = "Thanks for the feedback"
		redirect_to "https://billplz-staging.herokuapp.com/bills/#{params[:bill_id]}"
	end


	private

	def set_parent
		@parent = Parent.find(current_parent.id)
	end
end