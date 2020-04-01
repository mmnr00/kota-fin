class ClassroomsController < ApplicationController

	before_action :set_admin
	
	def index
		@classrooms = Classroom.all
	end

	def new
		@taska = Taska.find(params[:community_id])
		@admin = current_admin
		@classroom = Classroom.new
		render action: "new", layout: "admin_db/admin_db-resident" 
	end

	def create
		@admin = current_admin
		@classroom = Classroom.new(classroom_params)
		@classroom.classroom_name = @classroom.classroom_name.upcase
		@classroom.description = @classroom.description.upcase
		if @classroom.save
				@taska = Taska.find(@classroom.taska_id)
        flash[:notice] = "New Resident Successfully Created"
        redirect_to taskashow_path(@taska)
      else
        render :new      
      end
	end

	def edit
		@classroom = Classroom.find(params[:id])
		@admin = current_admin
		@taska = @classroom.taska
		render action: "edit", layout: "dsb-admin-classroom" 


	end

	def update
		@admin = current_admin
		@classroom = Classroom.find(params[:id])
		if @classroom.update(classroom_params)
				@taska = Taska.find(@classroom.taska_id)
        flash[:notice] = "Classroom was successfully edited"
        redirect_to classroom_index_path(@taska)
      else
        render :edit      
      end
	end

	def destroy
		@classroom = Classroom.find(params[:id])
		@admin = current_admin
		@taska = Taska.find(@classroom.taska_id)
		if @classroom.kids.count > 0 || @classroom.teachers.count > 0
			flash[:danger] = "Please remove all children and teachers before deleting"
		else
			if @classroom.destroy
				flash[:success] = "Classroom was successfully deleted"
			else
				flash[:danger] = "Classroom was unsuccessfully deleted. Please try again"
			end
		end
		
		redirect_to classroom_index_path(@taska)
	end

	def show
		@admin = current_admin
		@classroom = Classroom.find(params[:id])
		@taska = @classroom.taska
		@classroom_kids = @classroom.kids.order('name ASC')		
		render action: "show", layout: "dsb-admin-classroom" 	
	end

	def classroom_xls
		@admin = current_admin
		@classroom = Classroom.find(params[:id])
		@taska = @classroom.taska
		@classroom_kids = @classroom.kids.order('name ASC')
		respond_to do |format|
    	#format.html
    	format.xlsx{
  								response.headers['Content-Disposition'] = 'attachment; filename="Children List.xlsx"'
			}
  	end
		
	end

	def taskateachers_classroom
		@classroom = Classroom.find(params[:id])	
    	@taskateachers = @classroom.taska.teachers
    	
  end

  private

  def set_admin
  	@admin = current_admin
  	if @admin.present?
  		@spv = @admin.spv
  	end
  end

  def classroom_params
      params.require(:classroom).permit(:classroom_name,
		                                    :taska_id,
		                                    :description,
		                                    :base_fee
		                                    )
    end

end