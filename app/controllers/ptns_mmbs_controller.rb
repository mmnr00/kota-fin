class PtnsMmbsController < ApplicationController
	
	def new
		@ptnsmmb = PtnsMmb.new
	end

	def create
		@ptnsmmb = PtnsMmb.new(ptnsmmb_params)
		icf = "#{@ptnsmmb.ic1}#{@ptnsmmb.ic2}#{@ptnsmmb.ic3}"
		if PtnsMmb.where(icf: icf).present?
			flash[:notice] = "NAMA ANDA SUDAH DIDAFTARKAN DALAM SISTEM KAMI"
			redirect_to new_ptns_mmb_path
		else
			@ptnsmmb.icf = icf
			@ptnsmmb.save
		end	
	end

	def find_ptns
    if params[:ic1].blank? || params[:ic2].blank? || params[:ic3].blank? 
      flash.now[:danger] = "Maklumat tidak lengkap"
    else
    	icf = "#{params[:ic1]}#{params[:ic2]}#{params[:ic3]}"
      @ptns_find = PtnsMmb.where(icf: icf)
      flash.now[:danger] = "Tiada rekod" unless @ptns_find.present?
    end
    respond_to do |format|
      format.js { render partial: 'ptns_mmbs/result' } 
    end
  end

	def edit
		@ptnsmmb = PtnsMmb.find(params[:id])
	end

	def update
		@ptnsmmb = PtnsMmb.find(params[:id])
		if @ptnsmmb.update(ptnsmmb_params)
			flash[:notice] = "Maklumat anda telah dikemaskini"
			redirect_to new_ptns_mmb_path
			
		else
			render 'edit'
		end
	end

	def destroy
	end

	private

	def ptnsmmb_params
     params.require(:ptns_mmb).permit(:name,
																		:dob,
																		:ic1,
																		:ic2,
																		:ic3,
																		:ph1,
																		:ph2,
																		:mmb,
																		:edu,
																		:add1,
																		:add2,
																		:city,
																		:state,
																		:postcode,
																		:ts_name,
																		:ts_add1,
																		:ts_add2,
																		:ts_city,
																		:ts_state,
																		:ts_postcode,
																		:ts_status,
																		:ts_owner,
																		:ts_job,
																		:ts_ph1,
																		:ts_ph2)
   end


end