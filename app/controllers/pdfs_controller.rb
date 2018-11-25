class PdfsController < ApplicationController

	def print_payment_course
		@payment = Payment.find(params[:payment])
		@teacher = Teacher.find(@payment.teacher_id)
		@course = Course.find(@payment.course_id)
		respond_to do |format|
	 		format.html
	 		format.pdf do
		   render pdf: "file_name",
		   template: "courses/payment.html.erb",
		   layout: 'dsb-teacher-edu.html.erb'
			end
		end
	end



end