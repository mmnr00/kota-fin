class TchdetailsController < ApplicationController
	before_action :set_tchdetail, except: [:new, :create]
	#before_action :rep_responsible?
	#before_action :authenticate_parent! || :authenticate_admin!
	def show
		@pdf = false
		@owner = Owner.find(params[:owner_id])
		@fotos = @tchdetail.fotos
		render action: "show", layout: "dsb-owner-college"
	end

	def show_pdf
		@pdf = true
		@owner = Owner.find(params[:owner_id])
		@fotos = @tchdetail.fotos
		respond_to do |format|
	 		format.html
	 		format.pdf do
		   render pdf: "(#{@tchdetail.name})",
		   template: "tchdetails/show_pdf.html.erb",
		   #disposition: "attachment",
		   #page_size: "A6",
		   orientation: "portrait",
		   layout: 'pdf.html.erb'
			end
		end
	end

	def new
		@teacher = Teacher.find(params[:teacher_id])
		@tchdetail = Tchdetail.new
		@tchdetail.fotos.build
		#render action: "new", layout: "dsb-teacher-edu"
	end

	def create
		@teacher = Teacher.find(params[:tchdetail][:teacher_id])
		@tchdetail = Tchdetail.new(tchdetail_params)
		#@tchdetail.marital = params[:marital]
		#@tchdetail.education = params[:education]
		#@expense.taska = session[:taska_id]
		if @tchdetail.save

			flash[:notice] = "Children was successfully created"
			redirect_to teacher_college_path(@teacher)

												
		else
			render @tchdetail.errors.full_messages
			render :new
		end
	end

	def edit
		@tchdetail = Tchdetail.find(params[:id])
		@teacher = @tchdetail.teacher

	
		
	end

	def update
		@tchdetail = Tchdetail.find(params[:id])
		@teacher = @tchdetail.teacher
		#@classroom = Classroom.find(params[:classroom])
		if @tchdetail.update(tchdetail_params)
			flash[:notice] = "Children was successfully updated"
			redirect_to teacher_college_path(@teacher)
			
		else
			render 'edit'
		end
	end

	private
	def set_tchdetail
		@tchdetail = Tchdetail.find(params[:id])
	end

	def tchdetail_params
      params.require(:tchdetail).permit(:name, 
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
      																	:education,
      																	:teacher_id,
      																	:ts_name,
      																	:ts_address_1,
      																	:ts_address_2,
      																	:ts_city,
      																	:ts_states,
      																	:ts_owner_name,
      																	:ts_phone_1,
      																	:ts_phone_2,
      																	fotos_attributes: [:foto, :picture, :foto_name] )
    end

end












