class WelcomesController < ApplicationController
	#before_action :authenticate_admin!
	before_action :allow_iframe_requests
	
	#layout "page"

	def cmbr19
		@taska = Taska.find(params[:id])
	end

	def cmbr19pdf
		@pdf = true
		respond_to do |format|
	 		format.html
	 		format.pdf do
		   render pdf: "[MBR 2019] #{params[:name].upcase}",
		   template: "welcomes/cmbr19pdf.html.erb",
		   disposition: "attachment",
		   #page_size: "A6",
		   zoom: 0.65,
		   # margin: {top: 10,
		   # 					bottom: 5,
		   # 					left: 10,
		   # 					right: 10
		   # },
		   orientation: "portrait",
		   layout: 'pdf.html.erb'
			end
		end
	end

	def index
		
	end

	def index2
		if params[:anis].present?
			redirect_to new_tchdetail_path(id: 62, anis: true)
		else
			@teacher = current_teacher
			@admin = current_admin
			@owner = current_owner
			@parent = current_parent
			render action: "index2", layout: "homepage2"
		end
		
	end

	def login
		#render action: "login", layout: "dashboard"
		if current_admin || current_teacher || current_parent
			if current_admin
				redirect_to admin_index_path
			elsif current_teacher
				redirect_to admin_index_path
			elsif current_parent
				redirect_to parent_index_path
			end
		end
	end

	def sb_dashboard

		render action: "sb_dashboard", layout: "dsb-admin-eg"

	end

	def sb_table
		#render action: "sb_table", layout: "dsb-admin-eg"
	end

	def star_rating
		render action: "star_rating", layout: "dsb-admin-eg"
	end



	private

	def allow_iframe_requests
  	response.headers.delete('X-Frame-Options')
	end

end
















