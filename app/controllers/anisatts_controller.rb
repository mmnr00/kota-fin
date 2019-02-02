class AnisattsController < ApplicationController


	def accept
		Anisatt.create(course_id: params[:course], tchdetail_id: params[:tchdetail], att: true)
		flash[:success] = "ATTENDANCE CONFIRMED"
		redirect_to owner_course_path(id: params[:owner], course: params[:course])
	end

	def remove
		att = Anisatt.where(course_id: params[:course], tchdetail_id: params[:tchdetail], att: true).first
		att.destroy
		flash[:success] = "ATTENDANCE REJECTED"
		redirect_to owner_course_path(id: params[:owner], course: params[:course])
	end


end