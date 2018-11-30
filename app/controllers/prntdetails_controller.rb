class PrntdetailsController < ApplicationController
	before_action :set_prntdetail, except: [:new, :create]

	def new
		@parent = Parent.find(params[:parent_id])
		@prntdetail = Prntdetail.new
	end

	def create
		@parent = Parent.find(params[:prntdetail][:parent_id])
		@prntdetail = Prntdetail.new(prntdetail_params)
		#@tchdetail.marital = params[:marital]
		#@tchdetail.education = params[:education]
		#@expense.taska = session[:taska_id]
		if @prntdetail.save

			flash[:notice] = "Children was successfully created"
			redirect_to parent_index_path												
		else
			#render @tchdetail.errors.full_messages
			render :new
		end
	end

	def edit
		@prntdetail = Prntdetail.find(params[:id])
		@parent = @prntdetail.parent
	end

	def update
		@prntdetail = Prntdetail.find(params[:id])
		@parent = @prntdetail.parent
		#@classroom = Classroom.find(params[:classroom])
		if @prntdetail.update(prntdetail_params)
			flash[:notice] = "Children was successfully updated"
			redirect_to parent_index_path			
		else
			render 'edit'
		end
	end

	private
	def set_prntdetail
		@prntdetail = Prntdetail.find(params[:id])
	end

	def prntdetail_params
      params.require(:prntdetail).permit(:name, 
      																	:ic_1, 
      																	:ic_2, 
      																	:ic_3, 
      																	:phone_1, 
      																	:phone_2, 
      																	:marital, 
      																	:address_1, 
      																	:address_2,
      																	:city,
      																	:states,
      																	:postcode,
      																	:parent_id)
    end

end


