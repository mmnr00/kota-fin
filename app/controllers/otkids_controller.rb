class OtkidsController < ApplicationController

	def crt_otkid
		otk = params[:otkid]
		@otkid = Otkid.new
		@otkid.amt = otk[:amt]
		@otkid.kid_id = otk[:kid_id]
		@otkid.save
		flash[:notice] = "Overtime successfully added"
		redirect_to new_bill_path(child: otk[:child], 
															classroom: otk[:classroom],
															month: otk[:month],
															year: otk[:year],
															id: otk[:id],
															discount: otk[:discount],
															addtn: otk[:addtn],
															desc: otk[:desc],
															exs: otk[:exs] )
	end

	def rmv_otkid
		@otkid = Otkid.find(params[:otkid_id])
		@otkid.destroy
		flash[:notice] = "Overtime successfully deleted"
		redirect_to new_bill_path(child: params[:child], 
															classroom: params[:classroom],
															month: params[:month],
															year: params[:year],
															id: params[:id],
															discount: params[:discount],
															addtn: params[:addtn],
															desc: params[:desc],
															exs: params[:exs] )
	end

end