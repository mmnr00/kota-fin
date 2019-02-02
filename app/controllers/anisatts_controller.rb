class AnisattsController < ApplicationController


	def accept
		Anisatt.create(course_id: params[:course], tchdetail_id: params[:tchdetail], anisprog_id: params[:prog], att: true)
		flash[:success] = "ATTENDANCE CONFIRMED"
		redirect_to partc_prog_path(id: params[:course], prog: params[:prog])
	end

	def remove
		att = Anisatt.where(course_id: params[:course], tchdetail_id: params[:tchdetail], anisprog_id: params[:prog], att: true).first
		att.destroy
		flash[:success] = "ATTENDANCE REJECTED"
		redirect_to partc_prog_path(id: params[:course], prog: params[:prog])
	end


end