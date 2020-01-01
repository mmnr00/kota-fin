class ApplvsController < ApplicationController

	def apply
		@applv = Applv.new(applv_params)
		# calculate no of leave days
		kind = @applv.kind
		if kind == "HALF DAY AM" || kind == "HALF DAY PM"
			half = true
			kind_name = kind
		else
			half = false
			kind_name = Tsklv.find(kind).name.upcase
		end

		if half
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
			
			if @applv.save && 1==0
			# if 1==1
				#SEND EMAIL
				taska = @applv.taska
				teacher = @applv.teacher
				tchd = teacher.tchdetail
				mail = SendGrid::Mail.new
				mail.from = SendGrid::Email.new(email: 'do-not-reply@kidcare.my', name: 'KidCare')
				mail.subject = 'NEW LEAVE APPLICATION'
				#Personalisation, add cc
				personalization = SendGrid::Personalization.new
				personalization.add_to(SendGrid::Email.new(email: "#{taska.email}"))
				personalization.add_cc(SendGrid::Email.new(email: "#{teacher.email}"))
				mail.add_personalization(personalization)
				#add content
				logo = "https://kidcare-prod.s3.amazonaws.com/uploads/foto/picture/149/kidcare_logo_top.png"
				msg = "<html>
								<body>
									Hi <strong>#{taska.supervisor}</strong><br><br>

									<strong>#{tchd.name.upcase}</strong> had submitted leave application for your approval.<br>
									Further details are as below:<br>
									<ul>
									  <li><strong>LEAVE TYPE : </strong>#{kind_name}</li>
									  <li><strong>COMMENTS : </strong>#{@applv.tchdesc}</li>
									  <li><strong>START DATE : </strong>#{@applv.start.strftime('%d-%^b-%y')}</li>
									  <li><strong>END DATE : </strong>#{@applv.end.strftime('%d-%^b-%y')}</li>
									  <li><strong>DURATION : </strong>#{@applv.tot} day(s)</li>
									</ul><br>

									Please login to review the application. <br><br>

									Many thanks for your continous support.<br><br><br>

									Powered by <strong>www.kidcare.my</strong>
								</body>
							</html>"
				#sending email
				mail.add_content(SendGrid::Content.new(type: 'text/html', value: "#{msg}"))
				sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])
				@response = sg.client.mail._('send').post(request_body: mail.to_json)
				flash[:success] = "LEAVE REQUEST SUBMITTED"
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
		kind = @applv.kind
		if kind == "HALF DAY AM" || kind == "HALF DAY PM"
			half = true
			kind_name = kind
		else
			half = false
			kind_name = Tsklv.find(kind).name.upcase
		end
		if @applv.save
			#SEND EMAIL
				taska = @applv.taska
				teacher = @applv.teacher
				tchd = teacher.tchdetail
				mail = SendGrid::Mail.new
				mail.from = SendGrid::Email.new(email: 'do-not-reply@kidcare.my', name: 'KidCare')
				mail.subject = "LEAVE APPLICATION #{@applv.stat}"
				#Personalisation, add cc
				personalization = SendGrid::Personalization.new
				personalization.add_to(SendGrid::Email.new(email: "#{teacher.email}"))
				personalization.add_cc(SendGrid::Email.new(email: "#{taska.email}"))
				mail.add_personalization(personalization)
				#add content
				msg = "<html>
								<body>
									Hi <strong>#{tchd.name.upcase}</strong><br><br>


									<strong>#{taska.supervisor}</strong> had <strong>#{@applv.stat}</strong> your leave application.<br>
									The details are as below:<br>
									<ul>
									  <li><strong>LEAVE TYPE : </strong>#{kind_name}</li>
									  <li><strong>COMMENTS : </strong>#{@applv.tskdesc}</li>
									  <li><strong>START DATE : </strong>#{@applv.start.strftime('%d-%^b-%y')}</li>
									  <li><strong>END DATE : </strong>#{@applv.end.strftime('%d-%^b-%y')}</li>
									  <li><strong>DURATION : </strong>#{@applv.tot} day(s)</li>
									</ul><br>

									Many thanks for your continous support.<br><br><br>

									Powered by <strong>www.kidcare.my</strong>
								</body>
							</html>"
				#sending email
				mail.add_content(SendGrid::Content.new(type: 'text/html', value: "#{msg}"))
				sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])
				@response = sg.client.mail._('send').post(request_body: mail.to_json)
				flash[:notice] = "LEAVE UPDATED SUCCESSFULLY"
		else
			flash[:notice] = "UPDATE FAILED. PLEASE TRY AGAIN"
		end
		
		if par[:tch] == "tch"
			redirect_to tsk_tchleave_path(id: @applv.taska_id, tch_id: @applv.teacher_id)
		else
			redirect_to taskateachers_path(@applv.taska.id,
																		tb1_a: "active",
																		tb1_ar: "true",
																		tb1_d: "show active")
		end
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
		time = Time.now
		teacher = Teacher.find(tchid)
		#tchlvs = teacher.tchlvs
		applvs = teacher.applvs.where('extract(year  from start) = ?', time.year)
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