class AnisprogsController < ApplicationController

	def anisprog_new
		params.require(:anisprog).permit(:name, :lec, :course_id)
		@progs = Anisprog.new
		@progs.name = params[:anisprog][:name] 
		@progs.lec = params[:anisprog][:lec]
		@progs.course_id = params[:anisprog][:course_id]  
		if @progs.save
			
			flash[:success] = "Done"
			redirect_to owner_course_path(course: @progs.course_id, id: current_owner.id)
		end

	end

	def anisprog_edit
		params.require(:anisprog).permit(:name, :lec, :course_id, :id)
		@progs = Anisprog.find(params[:anisprog][:id])
		@progs.name = params[:anisprog][:name] 
		@progs.lec = params[:anisprog][:lec]
		@progs.course_id = params[:anisprog][:course_id]  
		if @progs.save
			
			flash[:success] = "Done"
			redirect_to owner_course_path(course: @progs.course_id, id: current_owner.id)
		end
	end

	def anisprog_remove
	end

	
end