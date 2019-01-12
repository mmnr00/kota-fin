class KidsController < ApplicationController

	require 'json'
	before_action :set_kid, only: [:show, :kid_pdf]
	#before_action :set_kid_bill, only: [:bill_view]
	before_action :set_all
	before_action :authenticate_parent!, only: [:new]
	before_action :check_bill, only: [:bill_view, :bill_pdf]
	#before_action	:authenticate!, only: [:bill_view]
	#before_action :rep_responsible, only: [:bill_view]
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

	def remove_siblings
		s1 = Sibling.where(kid_id: params[:child], beradik_id: params[:beradik]).first
		s2 = Sibling.where(kid_id: params[:beradik], beradik_id: params[:child]).first
		s1.destroy
		s2.destroy
		kid = Kid.find(params[:child])
		kid.beradik.each do |beradik|
			if beradik.siblings.where(beradik_id: params[:beradik]).present?
				s1 = Sibling.where(kid_id: beradik.id, beradik_id: params[:beradik]).first
				s2 = Sibling.where(kid_id: params[:beradik], beradik_id: beradik.id).first
				s1.destroy
				s2.destroy
			end
		end
		redirect_to new_bill_path(id: params[:id],
                              child: params[:child],
                              classroom: params[:classroom],
                              month: params[:month],
                              year: params[:year],
                              discount: params[:discount],
                              addtn: params[:addtn],
                              desc: params[:desc])
	end

	def bill_view
		@pdf = false
		
		@payment = Payment.find(params[:payment]) 
		@kid = Kid.find(params[:kid])
		# if !current_admin.present?
		# 	if current_parent != @kid.parent
		# 		flash[:danger] = "You are not authorized to view this bill"
		# 		redirect_to parent_index_path
		# 	end
		# end
		@taska = Taska.find(params[:taska])
		if params[:classroom].present?
			@classroom = Classroom.find(params[:classroom])
		else
			@classroom = nil
		end
		@fotos = @taska.fotos
		if @payment.paid 
			redirect_to bill_pdf_path(payment: @payment.id, kid: @kid.id, taska: @taska.id, format: :pdf)
		end
	end

	def bill_pdf
		@pdf = true
		@payment = Payment.find(params[:payment]) 
		@kid = Kid.find(params[:kid])
		@taska = Taska.find(params[:taska])
		if params[:classroom].present?
			@classroom = Classroom.find(params[:classroom])
		else
			@classroom = nil
		end
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


	def new_admin
			@parent = current_parent
			@admin = current_admin
			@kid = Kid.new
			@taska = Taska.find(params[:taska_id])
			@fotos = @taska.fotos
			@kid.fotos.build
			#render action: "new", layout: "dsb-parent-child"	
	end


	def new
			@parent = current_parent
			@admin = current_admin
			@kid = Kid.new
			@taska = Taska.find(params[:taska_id])
			@fotos = @taska.fotos
			@kid.fotos.build
			#render action: "new", layout: "dsb-parent-child"	
	end

	def create
		@kid = Kid.new(kid_params)
		#@expense.taska = session[:taska_id]
		if @kid.save
			#Kidtsk.create(kid_id: @kid.id, taska_id: params[:kidtsk][:taska_id])
			# if @kid.fotos.where(foto_name: "BOOKING RECEIPT").first.present?			
			# 	flash[:notice] = "Children was successfully created"					
				redirect_to my_kid_path(@kid.parent)		
			# else
				#redirect_to parent_index_path;		 
				#redirect_to create_bill_booking_path(kid_id: @kid.id, taska_id: @kid.taska.id)
			# end							
		else
			flash[:danger] = "#{@kid.errors.full_messages}"
			render :new
		end
	end

	def edit
		@kid = Kid.find(params[:id])
		@parent = Parent.find(@kid.parent.id)
		@taska = @kid.taska
		#@classroom = Classroom.find(params[:classroom]) if @kid.classroom.present?
		#render action: "edit", layout: "dsb-parent-child"
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
		#@classroom = Classroom.find(params[:id])
		if params[:name].blank? 
			flash.now[:danger] = "You have entered an empty request"
		else
			#parent = Parent.find_by("email like?", "%#{params[:email]}%")
			#@parent_id = parent.id
			@kid_search = Kid.where("name like?", "%#{params[:name].upcase}%" )
			#@kid_search.each do |kid|
				#if (kid.parent.email == params[:email])
					#@kid_exist = kid
				#end
			#end
			
			flash.now[:danger] = "Children do not exist" unless @kid_search.present?
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
			if @kid.fotos.where(foto_name: "BOOKING RECEIPT").where(taska_id: @taska.id).last.present?			
				flash[:notice] = "#{@kid.name} was successfully registered to #{@taska.name}"					
				redirect_to my_kid_path(@parent)			
			elsif !@kid.payments.where(name: "TASKA BOOKING").where(paid: false).where(taska_id: @taska.id).last.present?
				#redirect_to parent_index_path;		 
				redirect_to create_bill_booking_path(kid_id: @kid.id, taska_id: @kid.taska.id)
			end			
			#flash[:success] = "#{@kid.name} has been added to #{@taska.name}"
    else
    	flash[:danger] = "Unsuccessful. Please try again"
    end
		#redirect_to my_kid_path(@parent)
	end

	def add_classroom
		@kid = Kid.find(params[:kid][:kid_id])
		@classroom = Classroom.find(params[:kid][:classroom_id])
		@taska = @classroom.taska
		@kid.classroom_id = @classroom.id
		@kid.save
		flash[:notice] = "#{@kid.name} was successfully added to #{@classroom.classroom_name}"
		redirect_to unreg_kids_path(@taska)
	end

	def remove_classroom
		@kid = Kid.find(params[:kid])
		@kid.update(classroom_id: nil)
		flash[:notice] = "#{@kid.name} was successfully remove"
		redirect_to classroom_path(params[:classroom])
	end


	private

	def check_bill
		payment = Payment.find(params[:payment]) 
		#check payment status
		if !payment.paid 
			url_bill = "#{ENV['BILLPLZ_API']}bills/#{payment.bill_id}"
      data_billplz = HTTParty.get(url_bill.to_str,
              :body  => { }.to_json, 
                          #:callback_url=>  "YOUR RETURN URL"}.to_json,
              :basic_auth => { :username => "#{ENV['BILLPLZ_APIKEY']}" },
              :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
      #render json: data_billplz and return
      data = JSON.parse(data_billplz.to_s)
      if data["id"].present? && (data["paid"] == true)
      	payment.paid = data["paid"]
      	payment.save
      end
		end
	end

	def set_kid
		@kid = Kid.find(params[:id])
	end

	def set_kid_bill
		@kid = Kid.find(params[:kid])
	end

	def set_all
		@parent = current_parent
		@admin = current_admin
	end

	def authenticate!
   :authenticate_admin! || :authenticate_parent!
   @current_user = admin_signed_in? ? current_admin : current_parent
end

	def rep_responsible
		redirect_to new_parent_session_path unless current_parent == @kid.parent
	end
	
	def kid_params
      params.require(:kid).permit(:name, 
      														:parent_id,
      														:gender,
      														:ic_1,
																	:ic_2,
																	:ic_3,
																	:ph_1,
																	:ph_2,
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





