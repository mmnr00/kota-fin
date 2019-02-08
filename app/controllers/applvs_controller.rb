class ApplvsController < ApplicationController

	def apply
		@applv = Applv.new(applv_params)
		#@teacher = Teacher.find
		if 1==0 #start > end

		elsif 2==0  #conflict with other leaves

		elsif 3==0 #insufficent leave

		elsif 3==0 #half day leave not same date

		else
			if @applv.save
			# if 1==1
				flash[:success] = "LEAVE REQUEST CREATED"
			else
				flash[:success] = "PLEASE TRY AGAIN"
			end
			redirect_to tchleave_path(@applv.teacher.id,
																app_a: "",
																bel_a: "",
																stat_a: "active",
																app_ar: "false",
																bel_ar: "false",
																stat_ar: "true",
																app_d: "",
																bel_d: "",
																stat_d: "show active")
		end
	end

	private

	def applv_params
		params.require(:applv).permit(:kind, 
																	:start, 
																	:end, 
																	:tchdsc,
																	:tskdsc, 
																	:taska_id, 
																	:teacher_id,
																	:stat)

	end

end