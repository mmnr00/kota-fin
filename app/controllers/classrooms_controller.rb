class ClassroomsController < ApplicationController
	
	def index
		@classrooms = Classroom.all
	end

	def show
		@classroom = Classroom.find(params[:id])		
	end

	def taskateachers_classroom
		@classroom = Classroom.find(params[:id])	
    	@taskateachers = @classroom.taska.teachers
    	
  end

end