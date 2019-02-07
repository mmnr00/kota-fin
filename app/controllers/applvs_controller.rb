class ApplvsController < ApplicationController

	def apply
		@applv = Applv.new(applv_params)
		@applv.save
		redirect_to root_path
	end

	private

	def applv_params
		params.require(:applv).permit(:kind, 
																	:start, 
																	:end, 
																	:tchdsc,
																	:tskdsc, 
																	:taska_id, 
																	:teacher_id,
																	:stat)

	end

end