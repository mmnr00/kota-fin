class ApplvsController < ApplicationController

	def apply
		@applv = Applv.new(applv_params)
		# calculate no of leave days
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
		if @applv.start > @applv.end #start > end
			flash[:danger] = "START DATE MUST BE GREATER THAN END DATE"
			redirect_to tchleave_path(@applv.teacher.id,
																app_a: "active",
																app_ar: "true",
																app_d: "show active")

		elsif date_exist?(@applv.teacher.id, @applv.start, @applv.end) == true  #conflict with other leaves
			flash[:danger] = "DATE CONFLICT WITH ANOTHER APPLICATION"
			redirect_to tchleave_path(@applv.teacher.id,
																app_a: "active",
																app_ar: "true",
																app_d: "show active")

		elsif bal_suff?(@applv.teacher.id, @applv.kind, @applv.tot) == true
			flash[:danger] = "INSUFFICIENT LEAVE BALANCE"
			redirect_to tchleave_path(@applv.teacher.id,
																app_a: "active",
																app_ar: "true",
																app_d: "show active")

		elsif (@applv.kind == "HALF DAY AM" || @applv.kind == "HALF DAY PM") && (@applv.start != @applv.end) #half day leave not same date
			flash[:danger] = "DATE MUST BE THE SAME FOR HALF DAY APPLICATION"
			redirect_to tchleave_path(@applv.teacher.id,
																app_a: "active",
																app_ar: "true",
																app_d: "show active")
		else
			
			if @applv.save
			#if 1==1
				flash[:success] = "LEAVE REQUEST CREATED"
			else
				flash[:success] = "PLEASE TRY AGAIN"
			end
			redirect_to tchleave_path(@applv.teacher.id,
																stat_a: "active",
																stat_ar: "true",
																stat_d: "show active")
		end
	end

	

	def tchupdate
		@applv2 = Applv.find(params[:id])
		@applv=Applv.new(applv_params)
		# calculate no of leave days
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
		if @applv.start > @applv.end #start > end
			flash[:danger] = "START DATE MUST BE GREATER THAN END DATE"
			redirect_to tchleave_path(@applv.teacher.id,
																app_a: "active",
																app_ar: "true",
																app_d: "show active")

		elsif date_exist?(@applv.teacher.id, @applv.start, @applv.end) == true  #conflict with other leaves
			flash[:danger] = "DATE CONFLICT WITH ANOTHER APPLICATION"
			redirect_to tchleave_path(@applv.teacher.id,
																app_a: "active",
																app_ar: "true",
																app_d: "show active")

		elsif bal_suff?(@applv.teacher.id, @applv.kind, @applv.tot) == true
			flash[:danger] = "INSUFFICIENT LEAVE BALANCE"
			redirect_to tchleave_path(@applv.teacher.id,
																app_a: "active",
																app_ar: "true",
																app_d: "show active")

		elsif (@applv.kind == "HALF DAY AM" || @applv.kind == "HALF DAY PM") && (@applv.start != @applv.end) #half day leave not same date
			flash[:danger] = "DATE MUST BE THE SAME FOR HALF DAY APPLICATION"
			redirect_to tchleave_path(@applv.teacher.id,
																app_a: "active",
																app_ar: "true",
																app_d: "show active")
		else
			
			if @applv2.update(applv_params)
			#if 1==1
				flash[:success] = "LEAVE REQUEST UPDATE"
			else
				flash[:success] = "PLEASE TRY AGAIN"
			end
			redirect_to tchleave_path(@applv2.teacher.id,
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

	def admupdate
		par = params[:applv]
		@applv = Applv.find(par[:id])
		@applv.stat = par[:stat]
		@applv.tskdesc = par[:tskdesc]
		@applv.save
		flash[:notice] = "LEAVE UPDATED SUCCESSFULLY"
		redirect_to taskateachers_path(@applv.taska.id,
																		tb1_a: "active",
																		tb1_ar: "true",
																		tb1_d: "show active")
	end

	def revleave
		@applv = Applv.find(params[:id])
		@applv.stat = "PENDING"
		@applv.save
		flash[:notice] = "LEAVE REVERTED SUCCESSFULLY"
		if params[:tch] == "tch"
			redirect_to tsk_tchleave_path(id: @applv.taska_id, tch_id: @applv.teacher_id)
		else
			redirect_to taskateachers_path(@applv.taska.id,
																		tb5_a: "active",
																		tb5_ar: "true",
																		tb5_d: "show active")
		end
	end

	private

	def date_exist?(teacher_id, start, last)
		applvs = Teacher.find(teacher_id).applvs
		applvs.each do |lv|
			if (start<=lv.end) && (last>=lv.start)
				return true
				break
			end
		end		
	end

	def bal_suff?(tchid,kind,tot)
		teacher = Teacher.find(tchid)
		#tchlvs = teacher.tchlvs
		applvs = teacher.applvs
		taska = teacher.taska_teachers.where(stat: true).first.taska
		tsklvs = taska.tsklvs
		annlvtsk = tsklvs.where(name: "ANNUAL LEAVE").first
		if kind == "HALF DAY AM" || kind == "HALF DAY PM" || kind == "#{annlvtsk.id}"
			annlvtch = annlvtsk.tchlvs.where(teacher_id: tchid).first
			tot1 = applvs.where(kind: "HALF DAY AM").where.not(stat: "REJECTED").sum(:tot)
			tot2 = applvs.where(kind: "HALF DAY PM").where.not(stat: "REJECTED").sum(:tot)
			tot3 = applvs.where(kind: annlvtsk.id).where.not(stat: "REJECTED").sum(:tot)
			current_tot = tot1 + tot2 + tot3
			# if current_tot == 10
			if tot > (annlvtch.day - current_tot)
				return true
			end
		else
			lvtsk = tsklvs.where(id: kind).first
			lvtch = lvtsk.tchlvs.where(teacher_id: tchid).first
			current_tot = applvs.where(kind: lvtsk.id).where.not(stat: "REJECTED").sum(:tot)
			if tot > (lvtch.day - current_tot)
				return true
			end
		end
	end

	def applv_params
		params.require(:applv).permit(:kind, 
																	:start, 
																	:end, 
																	:tchdesc,
																	:tskdesc, 
																	:taska_id, 
																	:teacher_id,
																	:stat,
																	fotos_attributes: [:foto, :picture, :foto_name])

	end

end