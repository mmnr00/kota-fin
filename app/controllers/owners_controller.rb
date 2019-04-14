class OwnersController < ApplicationController
	before_action :authenticate_owner!
	before_action :set_owner

	def index
		render action: "index", layout: "dsb-owner-college"
		#render action: "index", layout: "eip"


	end
	

	private 

	def set_owner
		@owner = current_owner
	end

	
	
end