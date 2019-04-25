class OtkidsController < ApplicationController

	def crt_otkid
		otk = params[:otkid]
		@otkid = Otkid.new
		@otkid.amt = otk[:amt]
		@otkid.kid_id = otk[:kid_id]
		@otkid.save
		redirect_to root_path
	end

	def rmv_otkid
		@otkid = Otkid.find(params[:otkid_id])
		@otkid.destroy
		redirect_to root_path
	end

end