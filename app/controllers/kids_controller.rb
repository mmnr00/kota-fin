class KidsController < ApplicationController
	#before_action :set_kid, only: [:add_classroom]
	#before_action :rep_responsible?
	#before_action :authenticate_parent! || :authenticate_admin!

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

	def edit
		@kid = Kid.find(params[:id])
		@classroom = Classroom.find(params[:classroom]) if @kid.classroom.present?
	end

	def update
		@kid = Kid.find(params[:id])
		#@classroom = Classroom.find(params[:classroom])
		if @kid.update(kid_params)
			flash[:notice] = "Children was successfully updated"
			if (current_admin)
				redirect_to classroom_path(@kid.classroom_id)
			else 
				redirect_to parent_index_path(@kid.parent)
			end
			
		else
			render 'edit'
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

	def add_classroom
		@kid = Kid.find(params[:kid])
		@kid.update(classroom_id: params[:classroom])
		flash[:notice] = "#{@kid.name} was successfully added"
		redirect_to classroom_path(params[:classroom])
	end

	def remove_classroom
		@kid = Kid.find(params[:kid])
		@kid.update(classroom_id: nil)
		flash[:notice] = "#{@kid.name} was successfully remove"
		redirect_to classroom_path(params[:classroom])
	end


	private

	def rep_responsible?
		@parent.present? || @admin.present?
	end
	
	def kid_params
      params.require(:kid).permit(:name, :classroom_id, :parent_id)
    end

end