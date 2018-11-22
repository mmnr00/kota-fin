class CoursesController < ApplicationController

	before_action :set_course, only: [:destroy ,:update, :edit]


	def index
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



	private

	def set_course
		@course = Course.find(params[:id])
	end

	def course_params
			params.require(:course).permit(:name, :college_id, :base_fee, :description)
	end

end