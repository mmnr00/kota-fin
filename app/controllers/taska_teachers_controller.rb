class TaskaTeachersController < ApplicationController

	def remove_teacher
		tsktch = TaskaTeacher.where(taska_id: params[:taska], teacher_id: params[:teacher], stat: true).first
		tsktch.stat = false
		tsktch.save
		flash[:notice]="Teacher successfully deleted"
		redirect_to taskateachers_path(params[:taska])
	end

	def create
		taska = Taska.find(params[:id])
		teacher = Teacher.find(params[:teacher])
		@teachers_taska = TaskaTeacher.create(taska: taska, teacher: teacher)
		flash[:success] = "Teacher #{@teachers_taska.teacher.username} was successfully added"
		redirect_to taskateachers_path(params[:id])
	end

	def destroy
		@taska_teacher = TaskaTeacher.where(taska_id: params[:id], teacher_id: params[:teacher]).first
		@taska_teacher.destroy
		flash[:notice]="Teacher successfully deleted"
		redirect_to taskateachers_path(params[:id])
	end
end
