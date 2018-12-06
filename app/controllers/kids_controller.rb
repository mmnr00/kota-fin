class KidsController < ApplicationController
	before_action :set_kid, only: [:show, :kid_pdf]
	before_action :set_all
	#before_action :rep_responsible?
	#before_action :authenticate_parent! || :authenticate_admin!

	def show
		@pdf = false
		@admin = current_admin
		@fotos = @kid.fotos
		@taska = @kid.taska
		render action: "show", layout: "dsb-admin-classroom" 
	end

	def kid_pdf
		@pdf = true
		@admin = current_admin
		@fotos = @kid.fotos
		respond_to do |format|
	 		format.html
	 		format.pdf do
		   render pdf: "(#{@kid.name})",
		   template: "kids/kid_pdf.html.erb",
		   #disposition: "attachment",
		   #page_size: "A6",
		   orientation: "portrait",
		   layout: 'pdf.html.erb'
			end
		end
	end

	def bill_view
		@pdf = false
		@payment = Payment.find(params[:payment]) 
		@kid = Kid.find(params[:kid])
		@taska = Taska.find(params[:taska])
		@classroom = Classroom.find(params[:classroom])
		@fotos = @taska.fotos
	end

	def bill_pdf
		@pdf = true
		@payment = Payment.find(params[:payment]) 
		@kid = Kid.find(params[:kid])
		@taska = Taska.find(params[:taska])
		@classroom = Classroom.find(params[:classroom])
		@fotos = @taska.fotos
		respond_to do |format|
	 		format.html
	 		format.pdf do
		   render pdf: "Receipt for #{@kid.name} from #{@taska.name}",
		   template: "kids/bill_pdf.html.erb",
		   #disposition: "attachment",
		   #page_size: "A6",
		   #orientation: "landscape",
		   layout: 'pdf.html.erb'
			end
		end
	end



	def new
		@parent = Parent.find(params[:id])
		@kid = Kid.new
		@taska = Taska.find(params[:taska_id])
		@kid.fotos.build
		render action: "new", layout: "dsb-parent-child"
	end

	def create
		@kid = Kid.new(kid_params)
		#@expense.taska = session[:taska_id]
		if @kid.save
			#Kidtsk.create(kid_id: @kid.id, taska_id: params[:kidtsk][:taska_id])
			if @kid.fotos.where(foto_name: "BOOKING RECEIPT").first.present?			
				flash[:notice] = "Children was successfully created"					
				redirect_to parent_index_path;			
			else	 
				redirect_to create_bill_booking_path(kid_id: @kid.id, taska_id: @kid.taska.id)
			end							
		else
			flash[:danger] = "#{@kid.errors.full_messages}"
			render :new
		end
	end

	def edit
		@kid = Kid.find(params[:id])
		@parent = Parent.find(@kid.parent.id)
		@classroom = Classroom.find(params[:classroom]) if @kid.classroom.present?
		render action: "edit", layout: "dsb-parent-child"
	end

	def update
		@kid = Kid.find(params[:id])
		@parent = Parent.find(@kid.parent.id)
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

	def add_taska
		
		@kid = Kid.find(params[:kid_id])
		@parent = Parent.find(params[:parent_id])
		@taska = Taska.find(params[:taska_id])
		@kid.taska_id = @taska.id
		if @kid.save
			flash[:success] = "#{@kid.name} has been added to #{@taska.name}"
    else
    	flash[:danger] = "Unsuccessful. Please try again"
    end
		redirect_to my_kid_path(@parent)
	end

	def add_classroom
		@kid = Kid.find(params[:kid][:kid_id])
		@classroom = Classroom.find(params[:kid][:classroom_id])
		@taska = @classroom.taska
		@kid.classroom_id = @classroom.id
		@kid.save
		flash[:notice] = "#{@kid.name} was successfully added to #{@classroom.classroom_name}"
		redirect_to classroom_index_path(@taska)
	end

	def remove_classroom
		@kid = Kid.find(params[:kid])
		@kid.update(classroom_id: nil)
		flash[:notice] = "#{@kid.name} was successfully remove"
		redirect_to classroom_path(params[:classroom])
	end


	private

	def set_kid
		@kid = Kid.find(params[:id])
	end

	def set_all
		@parent = current_parent
		@admin = current_admin
	end

	def rep_responsible?
		@parent.present? || @admin.present?
	end
	
	def kid_params
      params.require(:kid).permit(:name, 
      														:parent_id,
      														:ic_1,
																	:ic_2,
																	:ic_3,
																	:dob,
																	:birth_place,
																	:arr_infam,
																	:allergy,
																	:fav_food,
																	:hobby,
																	:panel_clinic,
																	:mother_name,
																	:mother_phone,
																	:mother_job,
																	:mother_job_address,
																	:father_name,
																	:father_phone,
																	:father_job,
																	:father_job_address,
																	:income,
																	:alt_phone,
																	:date_enter,
																	:taska_id,
																	fotos_attributes: [:foto, :picture, :foto_name])
    end

end





