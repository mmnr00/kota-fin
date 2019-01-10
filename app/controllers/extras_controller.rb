class ExtrasController < ApplicationController

	def new
		@taska = Taska.find(params[:taska_id])
		@admin = current_admin
		@extra = Extra.new
		render action: "new", layout: "dsb-admin-classroom" 
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
		@extra = Extra.find(params[:id])
		@admin = current_admin
		@taska = @extra.taska
		render action: "edit", layout: "dsb-admin-classroom" 
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
															addtn: params[:kid][:addtn] )
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
															addtn: params[:addtn] )
	end

	private
	def extra_params
      params.require(:extra).permit(:name,
                                    :price,
                                    :taska_id
                                    )
    end

end