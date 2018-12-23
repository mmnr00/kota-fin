class PtnsspsController < ApplicationController

	def edit
		@ptnssp = Ptnssp.find(params[:id])
	end

	def update
		@ptnssp = Ptnssp.find(params[:id])
		@ptnssp.name = params[:ptnssp][:name]
		@ptnssp.strgh = params[:ptnssp][:strgh]
		@ptnssp.wkns = params[:ptnssp][:wkns]
		@ptnssp.opp = params[:ptnssp][:opp]
		@ptnssp.thr = params[:ptnssp][:thr]
		if @ptnssp.save
			flash[:success]= "Cadangan anda telah direkodkan. Sila pilih dari senarai dibawah untuk membuat perubahan"
			redirect_to ptns_sp_list_path
		end
	end

end