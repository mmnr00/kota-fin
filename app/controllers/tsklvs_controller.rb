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
        flash[:notice] = "#{@tsklv.name.upcase} was successfully created"
        redirect_to taskateachers_path(@taska)
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
        redirect_to taskateachers_path(@taska)
      else
        render :edit      
      end
	end

	def destroy
		@extra = Extra.find(params[:id])
		extra_name = @extra.name
		extra_id = @extra.id
		@admin = current_admin
		@taska = Taska.find(@extra.taska_id)
		@extra.taska_id = nil
		if @extra.save
			#KidExtra.where(extra_id: extra_id).delete_all
			flash[:success] = "#{extra_name.upcase} was successfully deleted"
		else
			flash[:danger] = "#{extra_name.upcase} was unsuccessfully deleted. Please try again"
		end
		redirect_to classroom_index_path(@taska)
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