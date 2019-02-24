class PayslipsController < ApplicationController

	def viewpsl
		@admin = current_admin
		@payslip = Payslip.find(params[:psl])
		@teacher = @payslip.teacher
		@taska = @payslip.taska
	end

	def pdfpsl
		@pdf = true
		@admin = current_admin
		@payslip = Payslip.find(params[:psl])
		@teacher = @payslip.teacher
		@taska = @payslip.taska
		respond_to do |format|
	 		format.html
	 		format.pdf do
		   render pdf: "Payslip",
		   template: "payslips/pdfpsl.html.erb",
		   #disposition: "attachment",
		   #page_size: "A6",
		   #orientation: "landscape",
		   layout: 'pdf.html.erb'
			end
		end
	end

	def dltpsl
		@payslip = Payslip.find(params[:psl])
		tch_id = @payslip.teacher.id
		tsk_id = @payslip.taska.id
		mthpsl = @payslip.mth
		yrpsl = @payslip.year
		if @payslip.destroy
			flash[:success] = "DELETION SUCCESSFUL"
		else
			flash[:danger] = "DELETION FAILED. PLEASE TRY AGAIN"
		end
		if params[:allpsl] == "true"
			redirect_to taskateachers_path(id: tsk_id,
                                    tb7_a: params[:tb7_a],
                                    tb7_ar: params[:tb7_ar],
                                    tb7_d: params[:tb7_d],
                                    mthpsl: mthpsl,
                                    yrpsl: yrpsl)
		else
			redirect_to tchpayslip_path(id: tsk_id, tch_id: tch_id)
		end
	end

end