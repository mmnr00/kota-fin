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

	def owner_course
		@owner = Owner.find(params[:id])
		@course = Course.find(params[:course])
		@course_teachers = @course.teachers
		@course_payments = @course.payments
	end

	def new
		@college = College.find(params[:id])
		@course = Course.new
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
	end

	def update
		if @course.update(course_params)
			flash[:notice] = "#{@course.name} was successfully updated"
			redirect_to show_owner_path(id: current_owner, college: @course.college.id), :method => :get;
		else
			render 'edit'
		end
	end

	def destroy
		@course.destroy
		flash[:notice] = "Expenses was successfully deleted"
		redirect_to show_owner_path(id: current_owner, college: @course.college.id), :method => :get;
	end



	private

	def set_course
		@course = Course.find(params[:id])
	end

	def course_params
			params.require(:course).permit(:name, :college_id, :base_fee, :description)
	end

end