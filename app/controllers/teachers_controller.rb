class TeachersController < ApplicationController
	before_action :authenticate_teacher!, except: [:search, :find]
	def index

	end

	def search

	end

	def find
		if params[:email].blank? || params[:username].blank? 
			flash.now[:danger] = "You have entered an empty request"
		else
			#session[:month] = params[:month]
			#session[:year] = params[:year]
			@teachers_search = Teacher.search(params[:email], params[:username])
			@teachers_search = @teachers_search.order('updated_at DESC')
			flash.now[:danger] = "You have entered an invalid stock" unless @teachers_search
		end
		respond_to do |format|
			format.js { render partial: 'teachers/result' } 
		end

	end
end