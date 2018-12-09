class PagesController < ApplicationController
	 require 'json'
	 before_action :set_all
	 before_action :superadmin, only: [:bank_status]

	#layout "dsb-admin-eg"

	def index
	end

	def about
	end

	def button
	end

	def charts
	end

	def icons
	end

	def invoice
	end
	
	def dashboard_v1
	end

	def tables
	end

	def bs_profile
	end

	def profile_card
	end

	def profile_card_edit
	end

	def pricing
	end

	def admin_card
		@taska = Taska.first
		render action: "admin_card", layout: "dsb-admin-classroom"
	end

	def button
	end

	def bank_status
		#@taska_super = Taska.all.order('bank_status ASC').order('billplz_reg ASC')
		#@taska_super = Admin.last.taskas.order('bank_status ASC').order('billplz_reg ASC')
		@taska_check = Taska.all #kena tukar balik in prod to taska all
		@taska_verify = @taska_check.where.not(bank_status: "verified")
		@taska_verify.each do |taska|
			url_bill = "#{ENV['BILLPLZ_API']}check/bank_account_number/#{taska.acc_no}"
	    data_billplz = HTTParty.get(url_bill.to_str,
	            :body  => { }.to_json, 
	                        #:callback_url=>  "YOUR RETURN URL"}.to_json,
	            :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
	            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
	    #render json: data_billplz and return
	    data = JSON.parse(data_billplz.to_s)
	    if data["name"] != "not found"
	      taska.bank_status = data["name"]
	      taska.save
    	end
	  end
		@taska_super = Taska.all.where(collection_id: nil).includes(:payments).order("payments.paid ASC").order('bank_status DESC').order('billplz_reg ASC')
	end

	def billplz_reg
		taska = Taska.find(params[:id])
		taska.billplz_reg = "YES"
		taska.save
		redirect_to bank_status_path
	end

	private

	def set_all
    @teacher = current_teacher
    @parent = current_parent
    @admin = current_admin  
    @owner = current_owner
  end

  def superadmin
		if ((!current_admin) || (current_admin != Admin.first))
			flash[:danger] = "You dont have access"
			redirect_to root_path
		end
  end

end