class PagesController < ApplicationController
	 require 'json'
	 before_action :set_all
	 before_action :superadmin, only: [:bank_status]

	#layout "dsb-admin-eg"

	def index
	end

	def tutorial
	end

	def tryroo
		@classroom = Classroom.all
	end

	def uploadroo
		xlsx = Roo::Spreadsheet.open(params[:file])
		header = xlsx.row(xlsx.first_row)
		((xlsx.first_row+1)..(xlsx.last_row)).each do |n|
		xlsx.row(n)
		row = Hash[[header, xlsx.row(n)].transpose]
			Classroom.create(classroom_name: row["NAME"], taska_id: row["TASKA"], base_fee: row["BASE FEE"])
		end
		flash[:success] = "FILE UPLOADED"
		redirect_to tryroo_path
	end

	

	def sendgrid
		mail = SendGrid::Mail.new
		mail.from = SendGrid::Email.new(email: 'do-not-reply@kidcare.my', name: 'KidCare')
		mail.subject = 'Test'
		#Personalisation, add cc
		personalization = SendGrid::Personalization.new
		personalization.add_to(SendGrid::Email.new(email: 'mmnr00@gmail.com', name: 'MUS'))
		personalization.add_cc(SendGrid::Email.new(email: 'admin@kidcare.my', name: 'Example User'))
		mail.add_personalization(personalization)
		#add content
		taska = Taska.find(1)
		msg = "<html>
						<body>
							<strong>#{taska.name}</strong>
						</body>
					</html>"
		#sending email
		mail.add_content(SendGrid::Content.new(type: 'text/html', value: "#{msg}"))
		sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])
		@response = sg.client.mail._('send').post(request_body: mail.to_json)
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

	def team_cards
	end

	def classroom_card
		@taska = Taska.first
		render action: "classroom_card", layout: "dsb-admin-classroom"
	end

	# start PTNSSP 
	def ptns_sp
	end

	def ptns_sp_reg
		@ptnssp = Ptnssp.new
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

	def ptns_sp_list
		@ptnssp_list = Ptnssp.all.order('updated_at DESC')
	end

	def sms

		@client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_KEY"])

		@client.messages.create(
			to: "+60174151556",
			from: ENV["TWILIO_PHONE_NO"],
			body: "Mus try from Rails. Please click here #{root_url}"

		)

	end

	

	# end PTNS SP

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