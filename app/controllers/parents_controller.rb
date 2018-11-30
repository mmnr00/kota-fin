class ParentsController < ApplicationController
	before_action :authenticate_parent!
	before_action :set_parent
	#$quarter = 3 || 6 || 9 || 12


	def index
		@parent = current_parent
		#@mykids = @parent.kids.order('updated_at DESC')
		@unpaid_bills = @parent.payments.where(paid: false).order("bill_month DESC")
		if @parent.prntdetail.present?
			redirect_to my_kid_path(@parent)
			#render action: "index", layout: "dsb-parent-child"
		else
			redirect_to new_prntdetail_path(parent_id: @parent.id)
		end
	end

	def my_kid
		@mykids = @parent.kids
		render action: "my_kid", layout: "dsb-parent-child"
	end

	def view_receipt
		@mykids = @parent.kids.order('created_at DESC')
		bills = @parent.payments.where(paid: true)
		@bills = bills.order('updated_at DESC')
	end

	def individual_bill
		@kid = Kid.find(params[:kid])
		@kid_bills = @kid.payments.where(bill_month: params[:month], bill_year: params[:year]) 
	end

	def parents_pay_bill

		@bill = Payment.find(params[:bill])
		#month = @bill.bill_month
		if (params[:dofeed] != "1")
			redirect_to "#{$billplz}bills/#{@bill.bill_id}" 
		else
			@kid = Kid.find(params[:kid])
			current_user = current_parent
			@feedback = Feedback.new
		end
		#feedback will be only on every quarter


	end

	def parents_feedback
		if (!params[:taska_rating].present? || !params[:classroom_rating].present?)
			flash[:danger] = "Please provide rating for both Taska & Classroom"
			redirect_to parents_pay_bill_path(id: @parent.id, 
                                        kid: params[:kid], 
                                        bill: params[:bill],
                                        bill_id: params[:bill_id],
                                        classroom_id: params[:classroom_id],
                                        dofeed: "1",
                                        taska_id: params[:taska_id])
		else 
			f_taska = Feedback.create(rating: params[:taska_rating],
																review: params[:taska_review], 
																taska_id: params[:taska_id])
			f_classroom = Feedback.create(rating: params[:classroom_rating],
																		review: params[:classroom_review],  
																		classroom_id: params[:classroom_id])
			flash[:success] = "Thanks for the feedback"
			redirect_to "#{$billplz}bills/#{params[:bill_id]}"
		end
	end


	private

	def set_parent
		@parent = Parent.find(current_parent.id)
	end

	def unpaid_bills

	end
end