class CollegesController < ApplicationController
	before_action :set_owner
	before_action :set_college, only: [:edit, :update, :destroy]

	def index
	end

	def new
		@college = College.new
		render action: "new", layout: "dsb-owner-college"
	end

	def create
		@college = College.new(college_params)
		if @college.save	
			@owner_college = OwnerCollege.create(owner_id:@owner.id, college_id:@college.id)
			@owner_college2 = OwnerCollege.create(owner_id:Owner.first.id, college_id:@college.id)			
			flash[:notice] = "College was successfully created"					
			#redirect_to owner_index_path;		
			redirect_to create_collection_college_path(@owner, college_id:@college.id) 							
		else
			render :new
		end
	end

	def show_owner
		@college = College.find(params[:college])
		@tchdetails = @college.tchdetails.order('name ASC')
		render action: "show_owner", layout: "dsb-owner-college"
	end

	def show_teacher
		@teacher = Teacher.find(params[:id])
		@college = College.find(params[:college])
		@teacher_payments = @teacher.payments
		render action: "show_teacher", layout: "dsb-teacher-edu"
	end

	def edit
		render action: "edit", layout: "dsb-owner-college"
	end

	def update
		if @college.update(college_params)
			flash[:notice] = "#{@college.name} was successfully updated"
			redirect_to owner_index_path
		else
			render 'edit'
		end
	end

	def destroy
		owner_college = OwnerCollege.where(college_id: @college.id) 
		owner_college.delete_all
		@college.destroy
		flash[:notice] = "Expenses was successfully deleted"
		redirect_to owner_index_path;
	end




	private

	def set_owner
		@owner = current_owner
	end

	def set_college
		@college = College.find(params[:id])
	end

	def college_params
			params.require(:college).permit(:name, :address)
	end

end





