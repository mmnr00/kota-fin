class PagesController < ApplicationController

	 before_action :set_all

	#layout "dsb-admin-eg"

	def index
	end

	def about
	end

	def button
	end

	def charts
	end

	def icons
	end

	def invoice
	end
	
	def dashboard_v1
	end

	def tables
	end

	def bs_profile
	end

	def profile_card
	end

	def pricing
	end

	def button
	end

	private

	def set_all
    @teacher = current_teacher
    @parent = current_parent
    @admin = current_admin  
    @owner = current_owner
  end

end