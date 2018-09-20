class ParentsController < ApplicationController
	before_action :authenticate_parent!
	def index

	end
end