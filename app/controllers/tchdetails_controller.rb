class TchdetailsController < ApplicationController
	before_action :set_tchdetail, except: [:new, :create, :find_tchdetail, :find_tchdetail_reg]
	#before_action :rep_responsible?
	#before_action :authenticate_parent! || :authenticate_admin!
	before_action :set_all

	def show
		@pdf = false
		if params[:owner_id].present?
			@owner = Owner.find(params[:owner_id])
		elsif params[:adm].present?
			@admin = Admin.find(params[:adm])
		end
		@fotos = @tchdetail.fotos
		if @owner 
			render action: "show", layout: "dsb-owner-college"
		end
	end

	def show_pdf
		@pdf = true
		if params[:owner_id].present?
			@owner = Owner.find(params[:owner_id])
		elsif params[:adm].present?
			@admin = Admin.find(params[:adm])
		end
		@fotos = @tchdetail.fotos
		respond_to do |format|
	 		format.html
	 		format.pdf do
		   render pdf: "(#{@tchdetail.name})",
		   template: "tchdetails/show_pdf.html.erb",
		   #disposition: "attachment",
		   #page_size: "A6",
		   orientation: "portrait",
		   layout: 'pdf.html.erb'
			end
		end
	end

	def new
		if params[:teacher_id].present?
			@teacher = Teacher.find(params[:teacher_id])
		end
		if params[:id].present?
			@college = College.find(params[:id])
		end
		@tchdetail = Tchdetail.new
		@tchdetail.fotos.build
		#render action: "new", layout: "dsb-teacher-edu"
	end

	def create
		@tchdetail = Tchdetail.new(tchdetail_params)
		pars = params[:tchdetail]
		if pars[:teacher_id].present? #teacher taska
			if @tchdetail.save
					redirect_to teacher_taska_path(@tchdetail.teacher)
			else
				render @tchdetail.errors.full_messages
				render :new
			end
		elsif pars[:college_id].present? #teacher college

			# @college = College.find(pars[:college_id])
			# owner = @college.owners.last

			# owner.colleges.each do |clg|
			# 	exs = clg.tchdetails.where(ic_1: @tchdetail.ic_1, ic_2: @tchdetail.ic_2, ic_3: @tchdetail.ic_3)
			# 	if exs.present?
			# 		break
			# 	end
			# end

			@college = College.find(pars[:college_id])
			owner = @college.owners.last
			tchdc = nil
			owner.colleges.each do |clg|
				if tchdc.blank?
					tchdc = clg.tchdetails
				else
					tchdc = tchdc.or(clg.tchdetails)
				end
			end

			exs = tchdc.where(ic_1: @tchdetail.ic_1, ic_2: @tchdetail.ic_2, ic_3: @tchdetail.ic_3)
			
			if exs.present?
				tchdclg = exs.first.tchdetail_colleges.first
				tchdclg.college_id = @college.id
				tchdclg.save
				@tchdetail = exs.first
			else
				if @tchdetail.save
					TchdetailCollege.create(college_id: @college.id, tchdetail_id: @tchdetail.id)
				else
					render @tchdetail.errors.full_messages
					render :new
				end
			end
			redirect_to tchd_anis_path(id: @tchdetail.id, anis: @tchdetail.anis)
		end
	end

	def create_old
		#@teacher = Teacher.find(params[:tchdetail][:teacher_id])

		@tchdetail = Tchdetail.new(tchdetail_params)
		#params.require(:tchdetail).permit(:college_id)
		#@tchdetail.marital = params[:marital]
		#@tchdetail.education = params[:education]
		#@expense.taska = session[:taska_id]
		if (exs = Tchdetail.where(ic_1: @tchdetail.ic_1, ic_2: @tchdetail.ic_2, ic_3: @tchdetail.ic_3).first).present?
			if @tchdetail.anis == "true"
				exs.anis = "true"
				flash[:danger] = "You already registered"
				redirect_to tchd_anis_path(id: exs.id, anis: true)
			else
				exs.update(tchdetail_params_exs)
				flash[:notice] = "Registration Successfull"
				redirect_to teacher_taska_path(exs.teacher)
			end
		else
			if @tchdetail.save
				TchdetailCollege.create(college_id: params[:tchdetail][:college_id], tchdetail_id: @tchdetail.id)
				flash[:success] = "REGISTRATION SUCCESSFULL"
				if @tchdetail.anis == "true"
					redirect_to tchd_anis_path(id: @tchdetail.id, anis: true)
				else
					redirect_to teacher_taska_path(@tchdetail.teacher)
				end								
			else
				render @tchdetail.errors.full_messages
				render :new
			end
		end

	end

	def tchd_anis
		@tchdetail = Tchdetail.find(params[:id])
		@fotos = @tchdetail.fotos
	end

	def find_tchdetail #find anis in college
		@college = College.find(params[:college_id])
		@course = Course.find(params[:course_id])
		@prog = Anisprog.find(params[:prog])
    if params[:ic3].blank? 
      flash.now[:danger] = "You have entered an empty request"
    else
      @tchdetail = @college.tchdetails.where(ic_3: params[:ic3])
      #flash.now[:danger] = "Cannot find child" unless @kid_search.present?
      flash.now[:danger] = "NO MATCHED DATA" unless @tchdetail.present?
    end
    respond_to do |format|
      format.js { render partial: 'tchdetails/result' } 
    end
  end

  def find_tchdetail_reg #find anis in reg
  	@clg = College.find(params[:id])
  	@own = @clg.owners.last
  	tchdc = nil
		@own.colleges.each do |clg|
			if tchdc.blank?
				tchdc = clg.tchdetails
			else
				tchdc = tchdc.or(clg.tchdetails)
			end
		end
    if params[:ic1].blank?
      flash.now[:danger] = "You have entered an empty request"
    elsif params[:ic1] == "ALL"
    	@find_tchdetail = Tchdetail.where(anis: "true")
    else
      @find_tchdetail = tchdc.where(ic_1: params[:ic1],ic_2: params[:ic2],ic_3: params[:ic3])
      #flash.now[:danger] = "Cannot find child" unless @kid_search.present?
      flash.now[:danger] = "NO REGISRTATION FOUND. PLEASE REGISTER BELOW" unless @find_tchdetail.present?
    end
    respond_to do |format|
      format.js { render partial: 'tchdetails/result-reg' } 
    end
  end

  def tchd_xls
  	if params[:all] == "true"
  		@colleges = @owner.colleges
  	else
	    @college = College.find(params[:id])
	    @tch_clg = @college.tchdetails.order('name ASC')
	  end
    respond_to do |format|
      #format.html
      format.xlsx{
                  response.headers['Content-Disposition'] = 'attachment; filename="Teacher List.xlsx"'
      }
    end
  end

	def new_old
		@teacher = Teacher.find(params[:teacher_id])
		@tchdetail = Tchdetail.new
		@tchdetail.fotos.build
		#render action: "new", layout: "dsb-teacher-edu"
	end

	def create_old
		@teacher = Teacher.find(params[:tchdetail][:teacher_id])
		@tchdetail = Tchdetail.new(tchdetail_params)
		#@tchdetail.marital = params[:marital]
		#@tchdetail.education = params[:education]
		#@expense.taska = session[:taska_id]
		if @tchdetail.save
			flash[:notice] = "Your profile was successfully created"
			if @tchdetail.teacher.present?
				redirect_to teacher_taska_path(@teacher)
			else
				redirect_to teacher_college_path(@teacher)
			end

												
		else
			render @tchdetail.errors.full_messages
			render :new
		end
	end

	def edit
		@tchdetail = Tchdetail.find(params[:id])
		@teacher = @tchdetail.teacher

	
		
	end

	def update
		@tchdetail = Tchdetail.find(params[:id])
		@teacher = @tchdetail.teacher
		#@classroom = Classroom.find(params[:classroom])
		if @tchdetail.update(tchdetail_params)
			flash[:notice] = "Teacher was successfully updated"
			if @tchdetail.teacher.blank?
			#if @tchdetail.anis == "true" && !params[:tsktch] == "true"
				redirect_to tchd_anis_path(id: @tchdetail.id, anis: @tchdetail.anis)
			else
				redirect_to teacher_taska_path(@teacher)
			end
			
		else
			render 'edit'
		end
	end

	private

	def set_all
		@admin = current_admin
		@owner = current_owner
		@teacher = current_teacher
		@parent = current_teacher
	end

	def set_tchdetail
		@tchdetail = Tchdetail.find(params[:id])
	end

	def tchdetail_params
      params.require(:tchdetail).permit(:name, 
      																	:ic_1, 
      																	:ic_2, 
      																	:ic_3, 
      																	:phone_1, 
      																	:phone_2, 
      																	:marital, 
      																	:email,
      																	:category,
      																	:address_1, 
      																	:address_2,
      																	:city,
      																	:states,
      																	:postcode,
      																	:education,
      																	:teacher_id,
      																	:ts_name,
      																	:ts_address_1,
      																	:ts_address_2,
      																	:ts_postcode,
      																	:ts_city,
      																	:ts_states,
      																	:ts_owner_name,
      																	:ts_phone_1,
      																	:ts_phone_2,
      																	:dun, 
      																	:jkm, 
      																	:post,
      																	:college_id,
      																	:anis,
      																	:income,
      																	:dob,
      																	:gender,
      																	fotos_attributes: [:foto, :picture, :foto_name] )
    end
    def tchdetail_params_exs
      params.require(:tchdetail).permit(:name, 
      																	:ic_1, 
      																	:ic_2, 
      																	:ic_3, 
      																	:phone_1, 
      																	:phone_2, 
      																	:marital, 
      																	:category,
      																	:address_1, 
      																	:address_2,
      																	:city,
      																	:states,
      																	:postcode,
      																	:education,
      																	:teacher_id,
      																	:income,
      																	:dob,
      																	:gender)
    end

end












