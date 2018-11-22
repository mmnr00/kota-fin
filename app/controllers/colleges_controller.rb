class CollegesController < ApplicationController
	before_action :set_owner

	def index
	end

	def new
		@college = College.new
	end

	def create
		@college = College.new(college_params)
		if @college.save	
			@owner_college = OwnerCollege.create(owner_id:@owner.id, college_id:@college.id)		
			flash[:notice] = "College was successfully created"					
			redirect_to owner_index_path;									
		else
			render :new
		end
	end

	def show_owner
		@college = College.find(params[:college])
	end




	private

	def set_owner
		@owner = current_owner
	end

	def college_params
			params.require(:college).permit(:name, :address)
	end

end





