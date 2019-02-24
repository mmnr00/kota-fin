class TsklvsController < ApplicationController

	def new
		@taska = Taska.find(params[:taska_id])
		@admin = current_admin
		@tsklv = Tsklv.new
		render action: "new", layout: "dsb-admin-teacher" 
	end

	def create
		@admin = current_admin
		@tsklv = Tsklv.new(tsklv_params)
		if @tsklv.save
				@taska = Taska.find(@tsklv.taska_id)
				@taska.taska_teachers.where(stat: true).each do |tch|
					@teacher = tch.teacher
					if @teacher.teachers_classrooms.present?
						Tchlv.create(name: @tsklv.name,
												day: @tsklv.day,
												taska_id: @taska.id,
												teacher_id: @teacher.id,
												tsklv_id: @tsklv.id)							
					end
				end
        flash[:notice] = "#{@tsklv.name.upcase} was successfully created"
        redirect_to taskateachers_path(@taska, 
        															tb4_a: "active",
		                                  tb4_ar: "true",
		                                  tb4_d: "show active")
      else
        render :new      
      end
	end

	def edit
		@tsklv = Tsklv.find(params[:id])
		@admin = current_admin
		@taska = @tsklv.taska
		render action: "edit", layout: "dsb-admin-teacher" 
	end

	def update
		@admin = current_admin
		@tsklv = Tsklv.find(params[:id])
		if @tsklv.update(tsklv_params)
				@taska = Taska.find(@tsklv.taska_id)
        flash[:notice] = "#{@tsklv.name.upcase} was successfully edited"
        redirect_to taskateachers_path(@taska, 
        															tb4_a: "active",
		                                  tb4_ar: "true",
		                                  tb4_d: "show active")
      else
        render :edit      
      end
	end

	def destroy
		@tsklv = Tsklv.find(params[:id])
		taska_id = @tsklv.taska.id
		Tchlv.where(tsklv_id: params[:id]).delete_all
		Applv.where(kind: @tsklv.id).delete_all
		@tsklv.destroy
		flash[:notice] = "DELETION SUCCESSFULL"
		redirect_to taskateachers_path(taska_id, 
    															tb4_a: "active",
                                  tb4_ar: "true",
                                  tb4_d: "show active")
	end

	

	private

	def tsklv_params
      params.require(:tsklv).permit(:name,
                                    :desc,
                                    :day,
                                    :taska_id
                                    )
  end

end