class TeachersController < ApplicationController
	before_action :authenticate_teacher!, except: [:search, :find, :show]
	before_action :set_teacher, only: [:index, :college, :add_college, :remove_college, :payment_signup]


	def index

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

	def college
		@college_list = College.all

	end

	def add_college
		teacher_college = TeacherCollege.new(teacher_id: params[:id], college_id: params[:college])
		if teacher_college.save
			flash.now[:success] = "Adding College Successful"
			redirect_to teacher_college_path
		else
			flash.now[:danger] = "Adding College Unsuccessful.Please try again"
			redirect_to teacher_college_path
		end
	end

	def remove_college
		teacher_college = TeacherCollege.where(teacher_id: params[:id], college_id: params[:college]).first
		if teacher_college.destroy
			flash.now[:success] = "Adding College Successful"
			redirect_to teacher_college_path
		else
			flash.now[:danger] = "Adding College Unsuccessful.Please try again"
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

	
	private
    
    def set_teacher
      @teacher = current_teacher
    end
    
end

















