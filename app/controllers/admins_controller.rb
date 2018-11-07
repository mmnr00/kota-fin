class AdminsController < ApplicationController
	before_action :authenticate_admin!
	def index
		@admin = current_admin
		@admin_taska = current_admin.taskas
		@admin_taska.each do |taska|
			@taska_id = taska.id
			@taska_name = taska.name
		end
		if @admin_taska.count == 1 ; redirect_to taska_path(@taska_id) end

	end

	def webarch
	end

	
end