class TeachersClassroomsController < ApplicationController
	def create
		classroom = Classroom.find(params[:id])
		teacher = Teacher.find(params[:teacher])
		@teachers_classrooms = TeachersClassroom.create(classroom: classroom, teacher: teacher)
		#flash[:success] = "Teacher #{@teachers_taska.teacher.username} was successfully added"
		redirect_to classroom_path(params[:id])
	end
=begin
	def destroy
		@taska_teacher = TaskaTeacher.where(taska_id: params[:id], teacher_id: params[:teacher]).first
		@taska_teacher.destroy
		flash[:notice]="Teacher successfully deleted"
		redirect_to taskateachers_path(params[:id])
	end
=end
end
