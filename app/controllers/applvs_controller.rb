class ApplvsController < ApplicationController

	def apply
		@applv = Applv.new(applv_params)
		#@teacher = Teacher.find
		if 1==0 #start > end

		elsif 2==0  #conflict with other leaves

		elsif 3==0 #insufficent leave

		elsif 3==0 #half day leave not same date

		else
			if @applv.kind == "HALF DAY AM" || @applv.kind == "HALF DAY PM"
				diff = 0.5
				plus = 0
				ph = 0
			else
				last = @applv.end
				start = @applv.start
				diff = (last - start).to_f
				plus = 1
				ph = 0
				(start..last).each do |dt|
					dayname = dt.strftime("%a")
					if (!$ph_sel19[dt.month].blank? && $ph_sel19[dt.month][dt.day].present?) || (dayname == "Sun" || dayname == "Sat" ) 
						ph = ph - 1
					end
				end
			end
			@applv.tot = (diff + plus + ph)
			if @applv.save
			#if 1==1
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

	

	def tchupdate
		@applv = Applv.find(params[:id])
		@applv.update(applv_params)
		@applv.save
		flash[:success] = "LEAVE SUCCESSFULLY UPDATED"
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

	def tchdelete
		@applv = Applv.find(params[:id])
		id = @applv.id
		@applv.destroy
		flash[:danger] = "LEAVE SUCCESSFULLY DELETED"
		redirect_to tchleave_path(id,
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

	private

	def applv_params
		params.require(:applv).permit(:kind, 
																	:start, 
																	:end, 
																	:tchdesc,
																	:tskdesc, 
																	:taska_id, 
																	:teacher_id,
																	:stat)

	end

end