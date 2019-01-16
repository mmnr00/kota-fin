class PtnsMmbsController < ApplicationController
	before_action :set_all
	
	def new
		@ptnsmmb = PtnsMmb.new
		@ptnsmmb.fotos.build
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
			flash[:notice] = "PENDAFTARAN BERJAYA. TERIMA KASIH. SILA IKUTI ARAHAN SETERUSNYA"
			redirect_to after_reg_ptns_path
		end	
	end

	def after_reg
	end

	def find_ptns
    if params[:ic1].blank? || params[:ic2].blank? || params[:ic3].blank? 
      flash.now[:danger] = "Maklumat tidak lengkap"
    else
    	icf = "#{params[:ic1]}#{params[:ic2]}#{params[:ic3]}"
      @ptns_find = PtnsMmb.where(icf: icf)
      flash.now[:danger] = "Tiada rekod. Sila daftar di ruangan dibawah" unless @ptns_find.present?
    end
    respond_to do |format|
      format.js { render partial: 'ptns_mmbs/result' } 
    end
  end

  def list_ptns
  	@all_mmb = PtnsMmb.all.order('created_at ASC')
  end

  def add_expire
  	params.require(:ptns_mmb).permit(:expire, :id)
  	mmb = PtnsMmb.find(params[:ptns_mmb][:id])
  	mmb.expire = params[:ptns_mmb][:expire]
  	if mmb.save
  		flash[:success] = "BERJAYA"
  	else
  		flash[:danger] = "TIDAK BERJAYA"
  	end
  	redirect_to list_ptns_path
  end

  def add_mmbid
  	params.require(:ptns_mmb).permit(:mmbid, :id)
  	mmb = PtnsMmb.find(params[:ptns_mmb][:id])
  	mmb.mmbid = params[:ptns_mmb][:mmbid]
  	if mmb.save
  		flash[:success] = "BERJAYA"
  	else
  		flash[:danger] = "TIDAK BERJAYA"
  	end
  	redirect_to list_ptns_path
  end

  def mmb_pdf
		@pdf = true
		@mmb = PtnsMmb.find(params[:id])
		respond_to do |format|
	 		format.html
	 		format.pdf do
		   render pdf: "(#{@mmb.name})",
		   template: "ptns_mmbs/mmb_pdf.html.erb",
		   #disposition: "attachment",
		   #page_size: "A6",
		   orientation: "portrait",
		   layout: 'pdf.html.erb'
			end
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
																		:ts_ph2,
																		:email,
																		fotos_attributes: [:foto, :picture, :foto_name])
   end

   def set_all
		@teacher = current_teacher
		@parent = current_parent
		@admin = current_admin	
		@owner = current_owner
  end


end