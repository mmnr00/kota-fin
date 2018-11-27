class TchdetailsController < ApplicationController
	before_action :set_tchdetail, except: [:new]
	#before_action :rep_responsible?
	#before_action :authenticate_parent! || :authenticate_admin!
	def new
		@tchdetail = Tchdetail.new
	end

	def create
		@tchdetail = Tchdetail.new(tchdetail_params)
		#@expense.taska = session[:taska_id]
		if @tchdetail.save			
			flash[:notice] = "Children was successfully created"					
			redirect_to root_path;									
		else
			render @tchdetail.errors.full_messages
			render :new
		end
	end

	def edit
		@tchdetail = Tchdetail.find(params[:id])
	end

	def update
		@tchdetail = Tchdetail.find(params[:id])
		#@classroom = Classroom.find(params[:classroom])
		if @tchdetail.update(tchdetail_params)
			flash[:notice] = "Children was successfully updated"
			redirect_to root_path
			
		else
			render 'edit'
		end
	end

	private
	def set_tchdetail
		@tchdetail = Tchdetail.find(params[:id])
	end

	def tchdetail_params
      params.require(:tchdetail).permit(:name, :ic_1, :ic_2, :ic_3, :phone_1, :phone_2)
    end

end