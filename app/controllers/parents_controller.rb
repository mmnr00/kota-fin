class ParentsController < ApplicationController
	before_action :authenticate_parent!
	before_action :set_parent, only: [:index]
	def index
		

	end


	private

	def set_parent
		@parent = Parent.find(current_parent.id)
	end
end