class TeachersClassroomsController < ApplicationController
	def create
		classroom = Classroom.find(params[:id])
		teacher = Teacher.find(params[:teacher])
		@teachers_classrooms = TeachersClassroom.create(classroom: classroom, teacher: teacher)
		#flash[:success] = "Teacher #{@teachers_taska.teacher.username} was successfully added"
		redirect_to classroom_path(params[:id])
	end

	def destroy #should have .first in finding the relation
		#classroom = Classroom.find(params[:id])
		teacher = Teacher.find(params[:teacher])
		@teachers_classrooms = TeachersClassroom.where(classroom_id: params[:id], teacher_id: params[:teacher]).first
		@teachers_classrooms.destroy
		flash[:notice]="#{teacher.username} successfully deleted"
		redirect_to classroom_path(params[:id])
	end

end
