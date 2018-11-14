class WelcomesController < ApplicationController
	#before_action :authenticate_admin!
	
	#layout "page"

	def index
		
	end

	def index2
		render action: "index2", layout: "homepage2"
		
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
		render action: "sb_dashboard", layout: "dashboard"
	end


end