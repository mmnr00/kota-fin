class PagesController < ApplicationController

	 before_action :set_all
	 before_action :superadmin, only: [:bank_status]

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

	def bank_status
	end

	private

	def set_all
    @teacher = current_teacher
    @parent = current_parent
    @admin = current_admin  
    @owner = current_owner
  end

  def superadmin
		if ((!current_admin) || (current_admin != Admin.first))
			flash[:danger] = "You dont have access"
			redirect_to root_path
		end
  end

end