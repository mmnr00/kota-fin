class TeachersController < ApplicationController
	before_action :authenticate_teacher!, except: [:search, :find, :show]
	before_action :set_teacher #, only: [:index, :college, :add_college, :remove_college, :payment_signup]


	def index
		#render action: "index", layout: "dsb-teacher-main"
		if params[:college_id].present? && params[:course_id].present?
			teacher_college = TeacherCollege.create(teacher_id: @teacher.id, college_id: params[:college_id])
			teacher_course = TeacherCourse.create(teacher_id: @teacher.id, course_id: params[:course_id])
		end
		if @teacher.tchdetail.present?
			redirect_to teacher_college_path(@teacher)
		else
			redirect_to new_tchdetail_path(teacher_id: @teacher.id)
		end

	end

	def show
		#@teacher = Teacher.find(params[:teacher])
	end

	def search

	end

	def find
		if params[:email].blank? || params[:username].blank? 
			flash.now[:danger] = "You have entered an empty request"
		else
			#session[:month] = params[:month]
			#session[:year] = params[:year]
			@teachers_search = Teacher.search(params[:email], params[:username])
			@teachers_search = @teachers_search.order('updated_at DESC')
			flash.now[:danger] = "You have entered an invalid stock" unless @teachers_search
		end
		respond_to do |format|
			format.js { render partial: 'teachers/result' } 
		end
	end

	#TASKA STUFF
	def taska

		@college_list = College.all
		render action: "taska", layout: "dsb-teacher-tsk"

	end

	def add_taska
		tsktch = TaskaTeacher.new(taska_id: params[:tsk_id], teacher_id: @teacher.id, stat: true)
		tsktch.save
		redirect_to teacher_taska_path(@teacher)
	end

	def find_taska
		if params[:name].blank? && params[:dom].blank?
      flash.now[:danger] = "Blank Input Received"
    else
    	if !params[:name].blank?
    		@taska_find = Taska.where(name: params[:name].upcase)
    	else
    		@taska_find = Taska.where(subdomain: params[:dom])
    	end
      flash.now[:danger] = "No record found" unless @taska_find.present?
    end
    respond_to do |format|
      format.js { render partial: 'teachers/resulttsk' } 
    end
	end

	def tchleave
		@tchlvs = @teacher.tchlvs
		@applv = Applv.new
		render action: "tchleave", layout: "dsb-teacher-tsk"
	end

	#END TASKA STUFF

	#COLLEGE STUFF

	def college

		@college_list = College.all
		render action: "college", layout: "dsb-teacher-edu"

	end

	def add_college
		teacher_college = TeacherCollege.new(teacher_id: params[:id], college_id: params[:college])
		if teacher_college.save
			flash[:success] = "Adding College Successful"
			redirect_to teacher_college_path
		else
			flash.now[:danger] = "Adding College Unsuccessful.Please try again"
			redirect_to teacher_college_path
		end

	end

	def remove_college
		teacher_college = TeacherCollege.where(teacher_id: params[:id], college_id: params[:college]).first
		if teacher_college.destroy
			flash[:danger] = "Remove College Successful"
			redirect_to teacher_college_path
		else
			flash[:danger] = "Remove Unsuccessful.Please try again"
			redirect_to teacher_college_path
		end
	end

	def payment_signup
		if (!TeacherCourse.where(teacher_id: @teacher.id, course_id: params[:course_id]).present?)
				TeacherCourse.create(teacher_id: @teacher.id, course_id: params[:course_id])
		end
		if (!TeacherCollege.where(teacher_id: @teacher.id, college_id: params[:college_id]).present?)
				TeacherCollege.create(teacher_id: @teacher.id, college_id: params[:college_id])
		end
		redirect_to show_teacher_path(@teacher, college: params[:college_id])

	end

	def teacher_pay_bill
		@course = Course.find(params[:course_id])
		@course_payment = Payment.where(teacher_id: @teacher.id, course_id: params[:course_id])
		render action: "teacher_pay_bill", layout: "dsb-teacher-edu"
	end

	
	private
    
    def set_teacher
      @teacher = current_teacher
    end
    
end

















