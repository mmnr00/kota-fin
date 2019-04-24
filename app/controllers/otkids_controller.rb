class OtkidsController < ApplicationController

	def crt_otkid
		otk = params[:otkid]
		@otkid = Otkid.new
		@otkid.amt = otk[:amt]
		@otkid.kid_id = otk[:kid_id]
		@otkid.save
		redirect_to root_path
	end

end