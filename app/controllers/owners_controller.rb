class OwnersController < ApplicationController
	before_action :authenticate_owner!
	before_action :set_owner

	def index

	end
	

	private 

	def set_owner
		@owner = current_owner
	end

	
	
end