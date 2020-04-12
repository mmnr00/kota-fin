desc "bill_mth"
task bill_mth: :environment do
	taska = Taska.where(rato: (Date.today.day+1))
	if taska.present?

		taska.each do |tsk|
			tot = 0.00
	    tsk.bilitm.each do |k,v|
	      tot = tot + v
	    end

			tsk.classrooms.each do |cls|
				@payment = Payment.new
				#CREATE BILLPLZ BILL
		    url_bill = "#{ENV['BILLPLZ_API']}bills"
		    data_billplz = HTTParty.post(url_bill.to_str,
		            :body  => { :collection_id => tsk.collection_id, 
		                        :email=> "bill@kota.my",
		                        :name=> "#{cls.description} #{cls.classroom_name}", 
		                        :amount=>  tot*100,
		                        :callback_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
		                        :redirect_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
		                        :description=>"Bill March"}.to_json, 
		                        #:callback_url=>  "YOUR RETURN URL"}.to_json,
		            :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
		            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
		    #render json: data_billplz and return
		    data = JSON.parse(data_billplz.to_s)
		    #CREATE PAYMENT
		    if data["id"].present?
		      @payment.amount = ((data["amount"].to_f)/100)
		      @payment.description = data["description"]
		      @payment.bill_month = Date.today.month
		      @payment.bill_year = Date.today.year
		      #@payment.discount = params[:payment][:discount]
		      #@payment.s2ph = params[:payment][:s2ph]
		      #@payment.parent_id = @kid.parent.id
		      @payment.taska_id = tsk.id
		      @payment.classroom_id = cls.id
		      @payment.state = data["state"]
		      @payment.paid = data["paid"]
		      @payment.bill_id = data["id"]
		      @payment.reminder = false
		      @payment.name = "RSD M BILL"
		      @payment.cltid = data["collection_id"]
		      @payment.save

		      #init payment details
		      if cls.topay == "OWNER"
		        ph = cls.own_ph
		        nm = cls.own_name
		        em = cls.own_email
		      elsif cls.topay == "TENANT"
		        ph = cls.tn_ph
		        nm = cls.tn_name
		        em = cls.tn_email
		      end
		      #send SMS
		      url = "https://sms.360.my/gw/bulk360/v1.4?"
		      usr = "user=admin@kidcare.my&"
		      ps = "#{ENV['SMS360']}"
		      to = "to=6#{ph}&"
		      txt = "text=hi+Mus+#{ENV['BILLPLZ_URL']}bills/#{data["id"]}"
		      data_sms = HTTParty.get("#{url}#{usr}#{ps}#{to}#{txt}")

		      #Create KidBill
		      KidBill.create(payment_id: @payment.id,
		                    extra: [nm,ph,em], 
		                    extradtl: tsk.bilitm,
		                    clsname: "#{cls.description} #{cls.classroom_name}"
		                    )


		    end
			end

		end

	end
	puts "Total #{taska.count}"
end


desc "try rake"
task try_sch: :environment do 
	cls = Classroom.all
	cls.each do |cl|
		puts cl.classroom_name
	end
end

