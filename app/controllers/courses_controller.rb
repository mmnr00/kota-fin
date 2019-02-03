class CoursesController < ApplicationController

	before_action :set_course, only: [:destroy ,:update, :edit]


	def index
	end

	def teacher_course
		@payment = Payment.new
		@teacher = Teacher.find(params[:id])
		@course = Course.find(params[:course])
		render action: "teacher_course", layout: "dsb-teacher-edu"
	end

	def payment
		@payment = Payment.find(params[:payment])
		@teacher = Teacher.find(@payment.teacher_id)
		@course = Course.find(@payment.course_id)
		@owner = current_owner
		if current_teacher
			render action: "payment", layout: "dsb-teacher-edu"
		elsif current_owner
			render action: "payment", layout: "dsb-owner-college"
		end
	end

	def payment_pdf
		@payment = Payment.find(params[:payment])
		@teacher = Teacher.find(@payment.teacher_id)
		@course = Course.find(@payment.course_id)
		respond_to do |format|
	 		format.html
	 		format.pdf do
		   render pdf: "Receipt for #{@course.name} (#{@teacher.username})",
		   template: "courses/payment_pdf.html.erb",
		   #disposition: "attachment",
		   #page_size: "A6",
		   #orientation: "landscape",
		   layout: 'pdf.html.erb'
			end
		end
		
	end

	def owner_course
		@owner = current_owner
		@progs = Anisprog.new
		@course = Course.find(params[:course])
		@prog_list = @course.anisprogs.order('start ASC')
		@college = @course.college
		@tchdetails = @college.tchdetails
		@course_teachers = @course.teachers.sort_by(&:created_at)
		@course_payments = @course.payments
		render action: "owner_course", layout: "dsb-owner-college"
	end

	def course_report
		@owner = current_owner
		@course = Course.find(params[:course])
		@college = @course.college
		@tchdetails = @college.tchdetails
		@attendance = Hash.new
		@attendance["ATTEND"] = Anisatt.where(course_id: @course.id).where(att: true).count
		@attendance["ABSENT"] = (@tchdetails.count*@course.anisprogs.count) - @attendance["ATTEND"]
		#render json: @attendance and return
		@anisfeed = Anisfeed.where(course_id: @course.id)
		@anisprogs = @course.anisprogs.order('start ASC')
		render action: "course_report", layout: "dsb-owner-college"
	end

	def anisprog_report
		@owner = current_owner
		@course = Course.find(params[:course])
		@prog = Anisprog.find(params[:prog])
		@fbc = @prog.feedbacks
		@anisfbc = @course.anisfeeds
		@tchds = @course.college.tchdetails
		@att = Hash.new
		@att["ATTEND"] = @prog.anisatts.count
		@att["ABSENT"] = @tchds.count - @att["ATTEND"]
		render action: "anisprog_report", layout: "dsb-owner-college"
	end

	def course_reportpdf
		@pdf = true
		@owner = current_owner
		@course = Course.find(params[:course])
		@college = @course.college
		@tchdetails = @college.tchdetails
		@attendance = Hash.new
		@attendance["ATTEND"] = Anisatt.where(course_id: @course.id).where(att: true).count
		@attendance["ABSENT"] = @tchdetails.count - @attendance["ATTEND"]
		#render json: @attendance and return
		@anisfeed = Anisfeed.where(course_id: @course.id)
		@anisprogs = @course.anisprogs
		respond_to do |format|
	 		format.html
	 		format.pdf do
		   render pdf: "(#{@course.name})",
		   template: "courses/course_reportpdf.html.erb",
		   #javascript_delay: 10000,
		   book: false,
		   #disposition: "attachment",
		   #page_size: "A6",
		   orientation: "portrait",
		   layout: 'pdf.html.erb'
			end
		end
		#render action: "course_report", layout: "dsb-owner-college"
	end

	def partc_prog
		@owner = current_owner
		@course = Course.find(params[:id])
		@prog = Anisprog.find(params[:prog])
		@tchdetails = @course.college.tchdetails
		render action: "partc_prog", layout: "dsb-owner-college"
	end

	def new
		@owner = current_owner
		@college = College.find(params[:id])
		@course = Course.new
		@course.fotos.build
		render action: "new", layout: "dsb-owner-college"
	end

	def create
		@course = Course.new(course_params)
		if @course.save
			flash[:notice] = "College was successfully created"					
			redirect_to show_owner_path(id: current_owner, college: @course.college.id), :method => :get;									
		else
			render :new
		end
	end

	def edit
		@owner = current_owner
		render action: "edit", layout: "dsb-owner-college"
	end

	def update
		@owner = current_owner
		if @course.update(course_params)
			flash[:notice] = "#{@course.name} was successfully updated"
			redirect_to show_owner_path(id: @owner.id, college: @course.college.id)
		else
			render 'edit'
		end
	end

	def destroy
		@owner = current_owner
		@course.destroy
		flash[:notice] = "Expenses was successfully deleted"
		redirect_to show_owner_path(id: current_owner, college: @course.college.id), :method => :get;
	end



	private

	def set_course
		@course = Course.find(params[:id])
	end

	def course_params
			params.require(:course).permit(	:name, 
																			:college_id, 
																			:base_fee, 
																			:description, 
																			:start,
																			:end,
																			fotos_attributes: [:foto, :picture, :foto_name])
			
	end

	


end





