class TeachersController < ApplicationController
	before_action :authenticate_teacher!, except: [:search]
	def index

	end

	def search

	end
end