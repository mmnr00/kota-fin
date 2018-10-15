class KidsController < ApplicationController

	def new
		@kid = Kid.new
	end

	def create
		@kid = Kid.new(kid_params)
		#@expense.taska = session[:taska_id]
		if @kid.save			
			flash[:notice] = "Children was successfully created"					
			redirect_to parent_index_path;									
		else
			render @kid.errors.full_messages
			render :new
		end
	end

	def search
		@classroom = Classroom.find(params[:id])
	end

	def find
		@classroom = Classroom.find(params[:id])
		if params[:email].blank? || params[:name].blank? 
			flash.now[:danger] = "You have entered an empty request"
		else
			parent = Parent.find_by("email like?", "%#{params[:email]}%")
			@parent_id = parent.id
			@kid_search = Kid.where("name like? AND parent_id like?", "%#{params[:name]}%", "%#{@parent_id}%" )
			#@kid_search.each do |kid|
				#if (kid.parent.email == params[:email])
					#@kid_exist = kid
				#end
			#end
			
			flash.now[:danger] = "You have entered an invalid details" unless @kid_search
		end
		respond_to do |format|
			format.js { render partial: 'kids/result' } 
		end

	end


	private
	def kid_params
      params.require(:kid).permit(:name, :classroom_id, :parent_id)
    end

end