class ParentsController < ApplicationController
	before_action :authenticate_parent!
	before_action :set_parent, only: [:index,:view_receipt]
	$quarter = 3 || 6 || 9 || 12

	def index
		@parent = current_parent
		@mykids = @parent.kids.order('updated_at DESC')
		@unpaid_bills = @parent.payments.where(paid: false)
	end

	def view_receipt
		@mykids = @parent.kids
		bills = @parent.payments.where(paid: true)
		@bills = bills.order('updated_at DESC	')
	end

	def individual_bill
		@kid = Kid.find(params[:kid])
		@kid_bills = @kid.payments.where(bill_month: params[:month], bill_year: params[:year]) 
	end

	def parents_pay_bill
		@kid = Kid.find(params[:kid])
		@bill = Payment.find(params[:bill])
		current_user = current_parent
		@feedback = Feedback.new
		if @bill.bill_month != $quarter; redirect_to "#{$billplz}bills/#{params[:bill_id]}" end

	end

	def parents_feedback
		f_taska = Feedback.create(rating: params[:taska_rating], 
															taska_id: params[:taska_id])
		f_classroom = Feedback.create(rating: params[:classroom_rating], 
																	classroom_id: params[:classroom_id])
		flash[:success] = "Thanks for the feedback"
		redirect_to "#{$billplz}bills/#{params[:bill_id]}"
	end


	private

	def set_parent
		@parent = Parent.find(current_parent.id)
	end

	def unpaid_bills

	end
end