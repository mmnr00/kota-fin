class WelcomesController < ApplicationController
	#before_action :authenticate_admin!
	def index
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
end