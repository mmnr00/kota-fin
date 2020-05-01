class ClassroomsController < ApplicationController

	before_action :set_admin

	def upd_vehicle
		pars = params[:vhcls]
		pars.each do |k,v|
			@vhcl = Vhcl.find(k)
			@vhcl.plt = v[:plt]
			@vhcl.brnd = v[:brnd]
			@vhcl.typ = v[:typ]
			@vhcl.save
		end
		flash[:success] = "Vehicle Update Successfully"
		redirect_to edit_vehicle_path(id: @vhcl.classroom_id)
	end

	def del_vehicle
		@vhcl = Vhcl.find(params[:id])
		@vhcl.destroy
		flash[:success] = "Vehicle Deleted Successfully"
		redirect_to edit_vehicle_path(id: params[:cls_id])
	end

	def add_vehicle
		
		pars = params[:vhc]
		clsr = Classroom.find(pars[:id])

		if clsr.vhcls.where(plt: pars[:plt].upcase).present?
			flash[:danger] = "Vehicle Already in Record"
		else
			@vhcl = Vhcl.new
			@vhcl.plt = pars[:plt].upcase
			@vhcl.brnd = pars[:brnd].upcase
			@vhcl.typ = pars[:typ].upcase
			@vhcl.classroom_id = pars[:id]
			if @vhcl.save
				flash[:success] = "Vehicle Successfully Created"
			else
				flash[:danger] = "Vehicle Creation Failed"
			end
		end

		redirect_to edit_vehicle_path(id: pars[:id])
	end

	def edit_vehicle
		@classroom = Classroom.find(params[:id])
		@vhcls = @classroom.vhcls.order('created_at ASC')
		@taska = @classroom.taska
		render action: "edit_vehicle", layout: "admin_db/admin_db-resident" 
	end

	def add_topay
		pars = params[:cls]
		pars.each do |k,v|
			@clas = Classroom.find(k)
			@clas.topay = v[:topay]
			@clas.classroom_name = v[:classroom_name].upcase
			@clas.description = v[:description].upcase
			@clas.own_name = v[:own_name].upcase
			@clas.own_dob = v[:own_dob]
			@clas.own_ph = v[:own_ph]
			@clas.own_email = v[:own_email].upcase
			@clas.tn_name = v[:tn_name].upcase
      @clas.tn_dob = v[:tn_dob]
      @clas.tn_ph = v[:tn_ph]
      @clas.tn_email = v[:tn_email].upcase
      if v[:ext_o].present?
      	@clas.ext_o = v[:ext_o]
      	@extra = Extra.find(v[:ext_o])
      	@extra.classroom_id = @clas.id
      	@extra.tp = "o"
      	@extra.save
      elsif v[:ext_t].present?
      	@clas.ext_t = v[:ext_t]
      	@extra = Extra.find(v[:ext_t])
      	@extra.classroom_id = @clas.id
      	@extra.tp = "t"
      	@extra.save
      end     
			@clas.save
		end 
		flash[:success] = "Data updated"
		redirect_to taskashow_path(@clas.taska_id)
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
		@taska = Taska.find(@classroom.taska_id)
		@classroom.classroom_name = @classroom.classroom_name.upcase
		@classroom.description = @classroom.description.upcase
		if @taska.classrooms.where(classroom_name:@classroom.classroom_name,description:@classroom.description).present?
			flash[:danger] = "Resident already exist"
			redirect_to add_unit_path(community_id: @taska.id)
		else
			unq = (0...6).map { ('a'..'z').to_a[rand(26)] }.join
			while Classroom.where(unq: unq).present?
				unq = (0...6).map { ('a'..'z').to_a[rand(26)] }.join
			end
			@classroom.unq = unq
			if @classroom.save
				Foto.create(foto_name:"Owner Pic",classroom_id: @classroom.id)
				Foto.create(foto_name:"Tenant Pic",classroom_id: @classroom.id)
				@taska = Taska.find(@classroom.taska_id)
	      flash[:notice] = "New Resident Successfully Created"
	      redirect_to taskashow_path(@taska)
	    else
	      render :back    
	    end
	  end

	end

	def edit
		@classroom = Classroom.find(params[:id])
		@taska = @classroom.taska
		render action: "edit", layout: "admin_db/admin_db-resident"  
	end

	def update
		@admin = current_admin
		@classroom = Classroom.find(params[:id])
		if @classroom.update(classroom_params)
				@taska = Taska.find(@classroom.taska_id)
        flash[:notice] = "Classroom was successfully edited"
        redirect_to taskashow_path(@taska)
      else
        render :edit      
      end
	end

	def destroy
		@classroom = Classroom.find(params[:id])
		@admin = current_admin
		@taska = Taska.find(@classroom.taska_id)
		if 1==0 #@classroom.kids.count > 0 || @classroom.teachers.count > 0
			flash[:danger] = "Please remove all children and teachers before deleting"
		else
			if @classroom.destroy
				flash[:success] = "Unit successfully deleted"
			else
				flash[:danger] = "Unit unsuccessfully deleted. Please try again"
			end
		end
		
		redirect_to taskashow_path(@taska)
	end

	def index
		@classrooms = Classroom.all
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