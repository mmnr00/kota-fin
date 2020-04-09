class ExtrasController < ApplicationController

	before_action :set_admin

	def reset_ajk
		@taska = Taska.find(params[:id])
		@extra = Extra.find(params[:ajk])
		@classroom = @extra.classroom
		if @extra.tp == "o"
			@classroom.ext_o = nil
		elsif @extra.tp == "t"
			@classroom.ext_t = nil
		end
		@extra.tp = nil
		@extra.classroom_id = nil

		@extra.save
		@classroom.save
		
		flash[:notice] = "Reset Successful for #{@extra.name}"
		redirect_to tsk_ajk_path(id: @taska.id)
	end

	def new
		@taska = Taska.find(params[:id])
		# @admin = current_admin
		@extra = Extra.new
		render action: "new", layout: "admin_db/admin_db-ajk" 
	end

	def create
		@admin = current_admin
		@extra = Extra.new(extra_params)
		if @extra.save
				@taska = Taska.find(@extra.taska_id)
        flash[:notice] = "#{@extra.name.upcase} was successfully created"
        redirect_to classroom_index_path(@taska)
      else
        render :new      
      end
	end

	def edit
		@taska = Taska.find(params[:id])
		# @extra = Extra.find(params[:id])
		# @admin = current_admin
		# @taska = @extra.taska
		render action: "edit", layout: "admin_db/admin_db-ajk" 
	end

	def update
		@admin = current_admin
		@extra = Extra.find(params[:id])
		if @extra.update(extra_params)
				@taska = Taska.find(@extra.taska_id)
        flash[:notice] = "#{@extra.name.upcase} was successfully edited"
        redirect_to classroom_index_path(@taska)
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
			KidExtra.where(extra_id: extra_id).delete_all
			flash[:success] = "#{extra_name.upcase} was successfully deleted"
		else
			flash[:danger] = "#{extra_name.upcase} was unsuccessfully deleted. Please try again"
		end
		redirect_to classroom_index_path(@taska)
	end

	def add_kid_extras
		@kid_extra = KidExtra.new
		@kid_extra.kid_id = params[:kid][:kid_id]
		@kid_extra.extra_id = params[:kid][:extra_ids]
		@kid_extra.save
		redirect_to new_bill_path(child: params[:kid][:child], 
															classroom: params[:kid][:classroom],
															month: params[:kid][:month],
															year: params[:kid][:year],
															id: params[:kid][:id],
															discount: params[:kid][:discount],
															addtn: params[:kid][:addtn],
															desc: params[:kid][:desc],
															exs: params[:kid][:exs] )
	end

	def remove_kid_extras
		@kid_extra = KidExtra.where(kid_id: params[:kid_id], extra_id: params[:extra_id]).first
		@kid_extra.destroy
		redirect_to new_bill_path(child: params[:child], 
															classroom: params[:classroom],
															month: params[:month],
															year: params[:year],
															id: params[:id],
															discount: params[:discount],
															addtn: params[:addtn],
															desc: params[:desc],
															exs: params[:exs] )
	end

	private

	def set_admin
  	@admin = current_admin
  	if @admin.present?
  		@spv = @admin.spv
  	end
  end

	def extra_params
      params.require(:extra).permit(:name,
                                    :price,
                                    :taska_id
                                    )
    end

end