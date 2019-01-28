class AnisfeedsController < ApplicationController

	before_action :set_all

	def anisfeed_pre
		#render action: "anisfeed_pre", layout: "dsb-owner-college"

	end

	def anisfeed_new
		@course = Course.find(params[:course])
		@college = @course.college
		
		if (@tchdetail = @college.tchdetails.where(ic_1: params[:ic1]).where(ic_2: params[:ic2]).where(ic_3: params[:ic3]).first).present?
			
			flash[:success] = "Hi #{@tchdetail.name}"
			redirect_to anisfeed_do_path(course: @course.id, tchdetail: @tchdetail.id)
		else
			flash[:danger] = "No record found. Please try again"
			redirect_to anisfeed_pre_path(id: params[:course])
		end	
		#render action: "anisfeed_new", layout: "dsb-owner-college"
	end

	def anisfeed_do
		@anisfeed = Anisfeed.new
		@course = Course.find(params[:course])
		@anisfeed.feedbacks.build
		@tchdetail = Tchdetail.find(params[:tchdetail])
		#render action: "anisfeed_do", layout: "dsb-owner-college"
	end

	def anisfeed_save
		@anisfeed = Anisfeed.new(anisfeed_params)
		if @anisfeed.save
			redirect_to anisfeed_pre_path(id: @anisfeed.course.id)
			flash[:notice] ="Feedback completed."
		else
			render :anisfeed_save
		end
	end

	private

	def anisfeed_params
		params.require(:anisfeed).permit(:rate,
																		:good,
																		:bad,
																		:course_id,
																		:tchdetail_id,
																		feedbacks_attributes: [:rating, :review, :anisprog_id])
	end

	def set_all
		@admin = current_admin
		@teacher = current_teacher
		@parent = current_parent
		@owner = current_owner
	end

end