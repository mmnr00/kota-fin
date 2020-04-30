class PaymentsController < ApplicationController
  require 'json'
  #ENV['BILLPLZ_API'] = "https://billplz-staging.herokuapp.com/api/v3/"
  #ENV['BILLPLZ_URL'] = "https://billplz-staging.herokuapp.com/"
  #ENV['BILLPLZ_APIKEY'] = "6d78d9dd-81ac-4932-981b-75e9004a4f11"
  before_action :set_all

  def crt_prev
    @taska = Taska.find(params[:tsk])
    classrooms = @taska.classrooms
    # get months and year
    all_month = []
    dt = Date.today + 1.months
    if params[:curr].present?
      curr_mth = [dt.month, dt.year]
      all_month << curr_mth
    else
      (1..@taska.booking.to_i).each do |p|
        curr_dt = dt - p.months
        curr_mth = []
        curr_mth << curr_dt.month
        curr_mth << curr_dt.year
        all_month << curr_mth
      end
    end

    #init for payment
    tot = 0.00
    @taska.bilitm.each do |k,v|
      tot = tot + v
    end
    #create payment for each classrooms
    classrooms.each do |cls|
      pmt = cls.payments
      no_bill = 0
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

      all_month.each do |m|
        # check no payment yet then only create payment 

        if pmt.where(bill_month: m[0], bill_year: m[1]).blank? && (tot > 0)
          no_bill = no_bill + 1
          #CREATE BILLPLZ BILL
          url_bill = "#{ENV['BILLPLZ_API']}bills"
          data_billplz = HTTParty.post(url_bill.to_str,
                  :body  => { :collection_id => @taska.collection_id, 
                              :email=> "bill@kota.my",
                              :name=> "#{cls.description} #{cls.classroom_name}", 
                              :amount=>  tot*100,
                              :callback_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                              :redirect_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                              :description=>"Bill for #{$month_name[m[0]]}-#{m[1]}"}.to_json, 
                              #:callback_url=>  "YOUR RETURN URL"}.to_json,
                  :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
                  :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
          #render json: data_billplz and return
          data = JSON.parse(data_billplz.to_s)
          #CREATE PAYMENT
          if data["id"].present?
            @payment = Payment.new
            @payment.amount = ((data["amount"].to_f)/100)
            @payment.description = data["description"]
            @payment.bill_month = m[0]
            @payment.bill_year = m[1]
            @payment.taska_id = @taska.id
            @payment.classroom_id = cls.id
            @payment.state = data["state"]
            @payment.paid = data["paid"]
            @payment.bill_id = data["id"]
            @payment.reminder = false
            @payment.name = "RSD M BILL"
            @payment.cltid = data["collection_id"]
            @payment.save

            #Create KidBill
            KidBill.create(payment_id: @payment.id,
                          extra: [nm,ph,em], 
                          extradtl: @taska.bilitm,
                          clsname: "#{cls.description} #{cls.classroom_name}"
                          )

            


          end # end Data ID

        end #End pmt not exist

      end #end loop month

      #send email and sms
      if params[:curr].present? && (no_bill > 0)

        #SEND EMAIL
        mail = SendGrid::Mail.new
        mail.from = SendGrid::Email.new(email: 'do-not-reply@kota.my', name: "#{@taska.name}")
        mail.subject = "NEW BILL FOR: NO #{cls.description} #{cls.classroom_name}"
        #Personalisation, add cc
        personalization = SendGrid::Personalization.new
        em = "billing123@kota.my" unless em.present?
        personalization.add_to(SendGrid::Email.new(email: "#{em}"))
        personalization.add_cc(SendGrid::Email.new(email: "#{@taska.email}"))
        mail.add_personalization(personalization)
        #add content
        msg = "<html>
                <body>
                  Hi <strong>#{nm}</strong><br><br>


                  Your new bill from <strong>#{@taska.name}</strong> is ready. <br><br>

                  Please click <a href=#{list_bill_url(cls: cls.id)}>HERE</a> to view and make payment. <br><br>

                  <strong>Taman Kita Tanggungjawab Bersama</strong>.<br><br>

                  Powered by <strong>www.kota.my</strong>
                </body>
              </html>"
        #sending email
        mail.add_content(SendGrid::Content.new(type: 'text/html', value: "#{msg}"))
        sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])
        @response = sg.client.mail._('send').post(request_body: mail.to_json)

        #SEND SMS
        url = "https://sms.360.my/gw/bulk360/v1.4?"
        usr = "user=admin@kidcare.my&"
        ps = "pass=#{ENV['SMS360']}&"
        to = "to=6#{ph}&"
        txt = "text=New Bill from #{@taska.name}.\n Click #{list_bill_url(cls: cls.id)} to view and make payment. Taman Kita Tanggungjawab Bersama. Thank You from KoTa.my"
        if Rails.env.production?
          
          fixie = URI.parse "http://fixie:2lSaDRfniJz8lOS@velodrome.usefixie.com:80"
          data_sms = HTTParty.get(
            "#{url}#{usr}#{ps}#{to}#{txt}",
            http_proxyaddr: fixie.host,
            http_proxyport: fixie.port,
            http_proxyuser: fixie.user,
            http_proxypass: fixie.password
          )
        else 
          #data = HTTParty.get("#{url}#{usr}#{ps}#{to}#{txt}")
        end


      end # end single email
    end # end classroom

    if tot > 0
      flash[:success] = "Complete bill for #{@taska.booking.to_i} months"
    else
      flash[:danger] = "Please update Bill Item in Fee Section"
    end
    redirect_to taskashow_path(@taska)
  end

  def man_pmt
    @taska = Taska.find(params[:tsk])
    @admin = current_admin
    @payment = Payment.find(params[:pmt])
    @kb = @payment.kid_bill
    render action: "man_pmt", layout: "admin_db/admin_db-fee" 
  end

  def upd_pmt
    pars = params[:bill]
    @taska = Taska.find(pars[:tsk])
    @payment = Payment.find(pars[:pmt])

    @payment.mtd = pars[:mtd]
    @payment.pdt = pars[:pdt]
    @payment.adm = pars[:adm]
    @payment.paid = true
    if @payment.save
      flash[:success] = "Bill Update Successful"
    else
      flash[:success] = "Bill Update Failed"
    end

    redirect_to tsk_fee_path(id: @taska.id,
                            sch_str: @payment.bill_id, 
                            sch_fld: "Bill ID",
                            sch: true)
  end

  def rev_pmt
    @taska = Taska.find(params[:tsk])
    @payment = Payment.find(params[:pmt])

    @payment.mtd = nil
    @payment.pdt = nil
    @payment.adm = nil
    @payment.paid = false
    if @payment.save
      flash[:success] = "Bill Revert Successful"
    else
      flash[:success] = "Bill Revert Failed"
    end
    redirect_to tsk_fee_path(id: @taska.id,
                            sch_str: @payment.bill_id, 
                            sch_fld: "Bill ID",
                            sch: true)
  end

  def del_pmt
  end

  def updall_pmt
    @taska = Taska.find(params[:id])
    @payments = @taska.payments.where(name: "RSD M BILL",paid: false)
    @payments.each do |pmt|

      nomore = false
      if pmt.bill_id2.present?
        bill_id = pmt.bill_id2
        mtd = "BILLPLZ via #{bill_id}"
        url_bill = "#{ENV['BILLPLZ_API']}bills/#{bill_id}"
        data_billplz = HTTParty.get(url_bill.to_str,
                :body  => {}.to_json, 
                            #:callback_url=>  "YOUR RETURN URL"}.to_json,
                :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
                :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
        #render json: data_billplz and return
        data = JSON.parse(data_billplz.to_s)
        if data["paid"] == true
          pmt.paid = true
          pmt.mtd = mtd
          pmt.pdt = data["paid_at"]
          pmt.save
          nomore = true
        else
          bill_id = pmt.bill_id
          mtd = "BILLPLZ"
        end
      else
        bill_id = pmt.bill_id
        mtd = "BILLPLZ"
      end

      if !nomore 
        url_bill = "#{ENV['BILLPLZ_API']}bills/#{bill_id}"
        data_billplz = HTTParty.get(url_bill.to_str,
                :body  => {}.to_json, 
                            #:callback_url=>  "YOUR RETURN URL"}.to_json,
                :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
                :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
        #render json: data_billplz and return
        data = JSON.parse(data_billplz.to_s)
        if data["paid"] == true
          pmt.paid = true
          pmt.mtd = mtd
          pmt.pdt = data["paid_at"]
          pmt.save
        end
      end

    end
    flash[:success] = "Bills Updated"
    redirect_to tsk_fee_path(id: @taska.id)
  end

  def mtl_pmt
    pars = params[:pmt]
    nxt = 0
    arr_pm = []
    pars.each do |k,v|
      paym = Payment.find(k)
      nxt = nxt + v.to_i
      arr_pm<<k unless v.to_i < 1
    end
    if nxt == 1 #pegi kt view_bill
      redirect_to view_bill_path(id: arr_pm[0])

    elsif nxt == 0 #pilih something
      flash[:danger] = "Please Choose a Bill to Pay"
      pym = Payment.find(pars.keys[0])
      redirect_to list_bill_path(cls: pym.classroom_id)

    else #create multiple bills

      @payments = Payment.where(id: arr_pm)
      @taska = @payments.first.taska
      @cls = @payments.first.classroom
      tot = @payments.sum(:amount)
      bill_ids = []
      @payments.each do |pm|
        bill_ids << pm.bill_id
      end

      #FIND OR CREATE COLLECTION
      bill_cnt = bill_ids.count
      if @taska.cltarr[bill_cnt].blank?
        url = "#{ENV['BILLPLZ_API']}collections"
        data_billplz = HTTParty.post(url.to_str,
                :body  => { :title => "#{bill_cnt}_#{@taska.name}",
                            :split_payment => {:email=>@taska.emblz,:fixed_cut=>(bill_cnt*150),:split_header=>true},
                          }.to_json, 
                            #:callback_url=>  "YOUR RETURN URL"}.to_json,
                :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
                :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
        #render json: data_billplz and return
        data = JSON.parse(data_billplz.to_s)
        @taska.cltarr[bill_cnt] = data["id"]
        @taska.save
      end



      #CREATE BILLPLZ BILL
      url_bill = "#{ENV['BILLPLZ_API']}bills"
      data_billplz = HTTParty.post(url_bill.to_str,
              :body  => { :collection_id => @taska.cltarr[bill_cnt], 
                          :email=> "bill@kota.my",
                          :name=> "#{@cls.description} #{@cls.classroom_name}", 
                          :amount=>  tot*100,
                          :reference_1_label => "Payment for Bill ID",
                          :reference_1 => bill_ids.to_s,
                          :callback_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                          :redirect_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                          :description=>"Bill For #{@cls.description} #{@cls.classroom_name}"}.to_json, 
                          #:callback_url=>  "YOUR RETURN URL"}.to_json,
              :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
              :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
      #render json: data_billplz and return
      data = JSON.parse(data_billplz.to_s)
      if data["id"].present?
        @payments.each do |pm|
          pm.bill_id2 = data["id"]
          pm.save
        end
        redirect_to "#{ENV["BILLPLZ_URL"]}bills/#{data["id"]}"
      else
        flash[:danger] = "Payment Unsuccessful. Please try again"
        redirect_to list_bill_path(cls: @cls.id)
      end


    end
  end

  def update
    @payments = Payment.where(bill_id2: "#{params[:billplz][:id]}")
    if @payments.present?
      @cls = @payments.first.classroom
      @payments.each do |bill|
        bill.paid = params[:billplz][:paid]
        bill.pdt = params[:billplz][:paid_at]
        bill.mtd = "BILLPLZ via #{params[:billplz][:id]}"
        bill.save
      end
      flash[:success] = "Payment Successful"
      redirect_to list_bill_path(cls: @cls.id, redr: 930289328)
    else
      @bill = Payment.where(bill_id: "#{params[:billplz][:id]}").first
      if @bill.present?
      #@kid = @bill.kid
        @bill.paid = params[:billplz][:paid]
        @bill.pdt = params[:billplz][:paid_at]
        @bill.mtd = "BILLPLZ"
        
        if @bill.paid
          @bill.save
          flash[:success] = "Bill was successfully paid"
        else
          flash[:danger] = "Bill was not paid due to bank rejection. Please try again"
        end
        redirect_to view_bill_path(id: @bill.id)
      end
    end
  end

  def crt_pmt
    @taska = Taska.find(params[:tsk])
    @cls = Classroom.find(params[:cls])
    @payment = Payment.new
    tot = 0.00
    @taska.bilitm.each do |k,v|
      tot = tot + v
    end

    #CREATE BILLPLZ BILL
    url_bill = "#{ENV['BILLPLZ_API']}bills"
    data_billplz = HTTParty.post(url_bill.to_str,
            :body  => { :collection_id => @taska.collection_id, 
                        :email=> "bill@kota.my",
                        :name=> "#{@cls.description} #{@cls.classroom_name}", 
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
      @payment.taska_id = @taska.id
      @payment.classroom_id = @cls.id
      @payment.state = data["state"]
      @payment.paid = data["paid"]
      @payment.bill_id = data["id"]
      @payment.reminder = false
      @payment.name = "RSD M BILL"
      @payment.cltid = data["collection_id"]
      @payment.save

      #init payment details
      if @cls.topay == "OWNER"
        ph = @cls.own_ph
        nm = @cls.own_name
        em = @cls.own_email
      elsif @cls.topay == "TENANT"
        ph = @cls.tn_ph
        nm = @cls.tn_name
        em = @cls.tn_email
      end
      #send SMS
      # url = "https://sms.360.my/gw/bulk360/v1.4?"
      # usr = "user=admin@kidcare.my&"
      # ps = "pass=kidCare@123&"
      # to = "to=6#{ph}&"
      # txt = "text=hi+Mus+#{ENV['BILLPLZ_URL']}bills/#{data["id"]}"
      # data_sms = HTTParty.get("#{url}#{usr}#{ps}#{to}#{txt}")

      #Create KidBill
      KidBill.create(payment_id: @payment.id,
                    extra: [nm,ph,em], 
                    extradtl: @taska.bilitm,
                    clsname: "#{@cls.description} #{@cls.classroom_name}"
                    )


    end


    flash[:danger] = "Mus"
    redirect_to taskashow_path(@taska)
  end


  def view_bill
    @payment = Payment.find(params[:id])
    @kb = @payment.kid_bill
    @taska = @payment.taska
    #@cls = @payment.classroom
    if params[:pdf].present?
      respond_to do |format|
        @pdf = true
        format.html
        format.pdf do
         render pdf: "Receipt from #{@taska.name}",
         template: "payments/view_bill.html.erb",
         #disposition: "attachment",
         #page_size: "A6",
         #orientation: "landscape",
         layout: 'pdf.html.erb'
        end
      end
    end
  end

  def list_bill
    if params[:redr].present?
      @shw = true
    else
      @shw = true
    end

    @comm = Classroom.find(params[:cls])
    if @comm.topay == "OWNER"
      @nm = @comm.own_name
    else
      @nm = @comm.tn_name
    end

    if params[:sub].present? && !@shw
      own_vr = (@comm.own_email == params[:em].upcase) && (@comm.own_ph == params[:ph]) && (@comm.own_dob == params[:dob].to_date)
      tn_vr = (@comm.tn_email == params[:em].upcase) && (@comm.tn_ph == params[:ph]) && (@comm.tn_dob == params[:dob].to_date)
      if own_vr || tn_vr
        #flash[:success] = "Details Verified"
        @shw = true
      else
        flash[:danger] = "Details do not matched. Please try again"
        redirect_to list_bill_path(cls: @comm.id)      
      end
    end

    @payments = @comm.payments.order('bill_year DESC').order('bill_month DESC').order('created_at DESC')

  end


  ## OLD KIDCARE ##
  def index
    @taska = Taska.find(params[:id])
  end

  def update_old
    if params[:taska].present? # for credit topup only
      @taska = Taska.find(params[:taska])
      url_bill = "#{ENV['BILLPLZ_API']}bills/#{params[:billplz][:id]}"
      data_billplz = HTTParty.get(url_bill.to_str,
              :body  => { }.to_json, 
                          #:callback_url=>  "YOUR RETURN URL"}.to_json,
              :basic_auth => { :username => "#{ENV['BILLPLZ_APIKEY']}" },
              :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
      #render json: data_billplz and return
      data = JSON.parse(data_billplz.to_s)
      if data["id"].present? && (data["paid"] == true)
        newarr = [(data["paid_amount"].to_f/100),data["paid_at"].to_time,data["id"]]
        modarr = @taska.hiscred.map { |x| x == data["id"] ? newarr : x }
        @taska.hiscred = modarr
        @taska.cred += data["paid_amount"].to_f/100
        @taska.save
        flash[:notice] = "Credit Reload Successful"
      else
        flash[:danger] = "Credit Reload Failed. Please try again"
      end
      redirect_to hiscrdt_path(id: params[:taska])
    else
      @bill = Payment.where(bill_id: "#{params[:billplz][:id]}").first
      if @bill.present?
      #@kid = @bill.kid
        @bill.paid = params[:billplz][:paid]
        @bill.pdt = params[:billplz][:paid_at]
        @bill.mtd = "BILLPLZ"
        @bill.save
        if @bill.paid
          flash[:success] = "Bill was successfully paid"
        else
          flash[:danger] = "Bill was not paid due to bank rejection. Please try again"
        end
        if (@bill.kids.present?)
          #@parent = @bill.parent
          redirect_to bill_view_path(payment: @bill.id , kid: @bill.kids.first.id, taska: @bill.taska.id)
        elsif (@bill.teacher.present?)
          redirect_to course_payment_pdf_path(payment: @bill.id, format: :pdf)
        elsif (@bill.taska.present?)
          @taska = @bill.taska
          if @bill.paid
            if (expire = @taska.expire) >= (my_time = Time.now)
              @taska.expire = expire + 1.months
            else
              @taska.expire = my_time + 1.months
            end
            @taska.save
          end
          redirect_to taska_path(@taska.id)
        end
      end
    end
  end

  def tsksvbill
    redirect_to unpaid_index_path(id: bill[:taska_id])
  end

  def create_collection
    @taska = Taska.find(params[:id])
    url_collection = "#{ENV['BILLPLZ_API']}collections/"
    title = @taska.name
    emails = @taska.email

    data_billplz = HTTParty.post(url_collection.to_str,
                  :body  => { :title => title,
                              :split_payment => {
                              :email => emails, 
                              :fixed_cut => 0, 
                              :split_header => true}
                            }.to_json,
                  :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
                  :headers => { 'Content-Type' => 'application/json', 
                                'Accept' => 'application/json' })
    data = JSON.parse(data_billplz.to_s)
    #render json: data_billplz and return
    if data["id"].present?
      @taska.collection_id = data["id"]
      @taska.save
      flash[:success] = "Collection Created"
    else
      flash[:danger] = "Please try again"
    end
    redirect_to bank_status_path
  end

  def create_collection_college
    @owner = Owner.find(params[:id])
    @college = College.find(params[:college_id])
    url_collection = "#{ENV['BILLPLZ_API']}collections/"
    title = "#{@college.name}""(college_id: #{@college.id})"
    email = @owner.email

    data_billplz = HTTParty.post(url_collection.to_str,
                  :body  => { :title => title,
                              :split_payment => {
                              :email => email, 
                              :fixed_cut => 0, 
                              :split_header => true}
                            }.to_json,
                  :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
                  :headers => { 'Content-Type' => 'application/json', 
                                'Accept' => 'application/json' })
    data = JSON.parse(data_billplz.to_s)
    @college.collection_id = data["id"]
    @college.save
    #render json: data_billplz
    redirect_to owner_index_path;
  end

  def view_invoice
    @parent = current_parent
    @payment = Payment.find(params[:id])
    @taska = @payment.taska
    @kid = @payment.kid
    render action: "view_invoice", layout: "dsb-parent-child"
  end

  def view_invoice_taska
    @pdf = false
    @taska = Taska.find(params[:taska])
    @payment = Payment.find(params[:payment])
    if !@payment.paid
      url_bill = "#{ENV['BILLPLZ_API']}bills/#{@payment.bill_id}"
      data_billplz = HTTParty.get(url_bill.to_str,
              :body  => {}.to_json, 
                          #:callback_url=>  "YOUR RETURN URL"}.to_json,
              :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
              :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
      #render json: data_billplz and return
      data = JSON.parse(data_billplz.to_s)
      if data["paid"] == true
        @payment.paid = true
        @payment.updated_at = data["paid_at"]
        @payment.save
        if (expire = @taska.expire) >= (my_time = Time.now)
          @taska.expire = expire + 1.months
        else
          @taska.expire = my_time + 1.months
        end
        @taska.save
      end
    end
  end

  def pdf_invoice_taska
    @pdf = true
    @taska = Taska.find(params[:taska])
    @payment = Payment.find(params[:payment])
    respond_to do |format|
      format.html
      format.pdf do
       render pdf: "Receipt for #{@taska.name}",
       template: "payments/pdf_invoice_taska.html.erb",
       #disposition: "attachment",
       #page_size: "A6",
       #orientation: "landscape",
       layout: 'pdf.html.erb'
      end
    end
  end



  def search_bill
    @taska = Taska.find(params[:taska_id])
    @taska_classrooms = @taska.classrooms
    @month = params[:month]
    @year = params[:year]
    #redirect_to display_children_path(@taska_classrooms)
  end

  def got_bill
    @taska = Taska.find(params[:taska])
    @kid = Kid.find(params[:child])
    @kid_bills = @kid.payments.where.not(name: "TASKA BOOKING").order('bill_year DESC').order('bill_month DESC')
    render action: "got_bill", layout: "dsb-admin-classroom" 
  end

  def chek_bill
    par = params[:payments]
    kid = Kid.find(par[:child])
    if kid.payments.where.not(name: "TASKA BOOKING").where(bill_month: par[:month]).where(bill_year: par[:year]).present?
      flash[:notice] = "BILL ALREADY EXIST FOR #{$month_name[par[:month].to_i]}-#{par[:year]}."
      # redirect_to got_bill_path(taska: par[:taska],
      #                           child: par[:child],
      #                           classroom: par[:classroom])
      redirect_to new_bill_path(id: par[:taska],
                                child: par[:child],
                                classroom: par[:classroom],
                                month: par[:month],
                                year: par[:year],
                                exs: 1)

    else
      redirect_to new_bill_path(id: par[:taska],
                                child: par[:child],
                                classroom: par[:classroom],
                                month: par[:month],
                                year: par[:year])
    end
  end

  def new
    @classroom = Classroom.find(params[:classroom])
    @taska = @classroom.taska
    @kid = Kid.find(params[:child])
    if 1==0
      redirect_to classroom_path(@classroom)
    else
      if (kid_share=params[:share_bill]).present?
        if !@kid.siblings.where(beradik_id: kid_share).present? #masuk yang share dulu
          Sibling.create(kid_id: @kid.id, beradik_id: kid_share)
          Sibling.create(kid_id: kid_share, beradik_id: @kid.id)
        end
        beradik = Kid.find(kid_share)
        @kid.siblings.each do |a| 
          if !beradik.siblings.where(beradik_id: a.beradik_id).present? && a.beradik_id != beradik.id
            Sibling.create(kid_id: beradik.id, beradik_id: a.beradik_id)
            Sibling.create(kid_id: a.beradik_id, beradik_id: beradik.id)
          end
        end
        beradik.siblings.each do |b|
          if !@kid.siblings.where(beradik_id: b.beradik_id).present? && b.beradik_id != @kid.id
            Sibling.create(kid_id: @kid.id, beradik_id: b.beradik_id)
            Sibling.create(kid_id: b.beradik_id, beradik_id: @kid.id)
          end
        end
      end

      @payment = Payment.new
      @payment.addtns.build
      render action: "new", layout: "dsb-admin-classroom" 
    end
  end

  def edit_bill
    @taska = Taska.find(params[:id])
    render action: "edit_bill", layout: "dsb-admin-classroom" 
  end

  def create
    params.require(:payment).permit(:amount, 
                            :description, 
                            :month, 
                            :year, 
                            :kid_id, 
                            :taska_id, 
                            :discount,
                            :exs,
                            :s2ph,
                            addtns_attributes: [:desc, :amount])
    amount = params[:payment][:amount].to_f*100
    if (desc = params[:payment][:description]) == ""
      desc = "NA"
    end
    
    @payment = Payment.new
    @addtn = Addtn.new
    @taska = Taska.find(params[:payment][:taska_id])
    exs = params[:payment][:exs]
    if exs.blank?
      collection_id = @taska.collection_id
    else
      collection_id = @taska.collection_id2
    end
    @kid = Kid.find(params[:payment][:kid_id])

    url_bill = "#{ENV['BILLPLZ_API']}bills"
    data_billplz = HTTParty.post(url_bill.to_str,
            :body  => { :collection_id => "#{collection_id}", 
                        :email=> "bill@kidcare.my",
                        :name=> "#{@kid.name}", 
                        :amount=>  amount,
                        :callback_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                        :redirect_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                        :description=>"#{desc}"}.to_json, 
                        #:callback_url=>  "YOUR RETURN URL"}.to_json,
            :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
    #render json: data_billplz and return
    data = JSON.parse(data_billplz.to_s)
    if data["id"].present?
      @payment.amount = params[:payment][:amount].to_f
      @payment.description = desc
      @payment.bill_month = params[:payment][:month]
      @payment.bill_year = params[:payment][:year]
      @payment.discount = params[:payment][:discount]
      @payment.s2ph = params[:payment][:s2ph]
      @payment.parent_id = @kid.parent.id
      @payment.taska_id = @kid.classroom.taska.id
      @payment.state = data["state"]
      @payment.paid = data["paid"]
      @payment.bill_id = data["id"]
      @payment.reminder = false
      @payment.name = "KID BILL"
      @payment.cltid = data["collection_id"]
      @payment.save
      @taska = @payment.taska
      @addtn.desc = params[:payment][:addtns_attributes]["0"][:desc]
      @addtn.amount = params[:payment][:addtns_attributes]["0"][:amount]
      @addtn.payment_id = @payment.id
      @addtn.save
      
      if exs.blank?
        cls = @kid.classroom.id
      else
        cls = nil
      end
      kb = KidBill.new(kid_id: @kid.id, payment_id: @payment.id, classroom_id: cls)
      kb.kidname = @kid.name
      kb.kidic = "#{@kid.ic_1}-#{@kid.ic_2}-#{@kid.ic_3}"
      if cls.present?
        clsr = @kid.classroom
        kb.clsname = clsr.classroom_name
        kb.clsfee = clsr.base_fee
      end
      if (ot = @kid.otkids.where(payment_id: nil).first).present?
        ot.payment_id = @payment.id
        ot.save
      end
      cnt=1
      @kid.extras.each do |extra|
        kb.extra << extra.id
        extra = Extra.find(extra.id)
        kb.extradtl["#{cnt}. #{extra.name}"] = extra.price
        cnt = cnt + 1
      end
      kb.save

      if @kid.beradik.count > 0
        @kid.beradik.each do |beradik|
          if exs.blank?
            cls = beradik.classroom.id
          else
            cls = nil
          end
          kb = KidBill.new(kid_id: beradik.id, payment_id: @payment.id, classroom_id: cls)
          kb.kidname = beradik.name
          kb.kidic = "#{beradik.ic_1}-#{beradik.ic_2}-#{beradik.ic_3}"
          if cls.present?
            clsr = beradik.classroom
            kb.clsname = clsr.classroom_name
            kb.clsfee = clsr.base_fee
          end
          cnt=1
          beradik.extras.each do |extra|
            kb.extra << extra.id
            extra = Extra.find(extra.id)
            kb.extradtl["#{cnt}. #{extra.name}"] = extra.price
            cnt = cnt + 1
          end
          kb.save
          if (ot = beradik.otkids.where(payment_id: nil).first).present?
            ot.payment_id = @payment.id
            ot.save
          end
        end

      end
      flash[:success] = "Bills created successfully and SMS send to #{@kid.ph_1}#{@kid.ph_2}"
      # start send sms to parents
      if 1==1 && (ENV["ROOT_URL_BILLPLZ"] != "https://kidcare-staging.herokuapp.com/")#Rails.env.production?
        @client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_KEY"])
        @client.messages.create(
          to: "+6#{@kid.ph_1}#{@kid.ph_2}",
          from: ENV["TWILIO_PHONE_NO"],
          body: "New bill from #{@taska.name} . Please click at this link <#{billview_url(payment: @payment.id, kid: @kid.id, taska: @kid.taska.id)}> to make payment"
        )
        
        if @payment.s2ph && @kid.sph_1.present? && @kid.sph_2.present?
          if @taska.cred >= 0.5
            @client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_KEY"])
            @client.messages.create(
              to: "+6#{@kid.sph_1}#{@kid.sph_2}",
              from: ENV["TWILIO_PHONE_NO"],
              body: "New bill from #{@taska.name} . Please click at this link <#{billview_url(payment: @payment.id, kid: @kid.id, taska: @kid.taska.id)}> to make payment"
            )
            @taska.cred -= 0.5
            @taska.hiscred << [-0.5,Time.now,"#{@kid.sph_1}#{@kid.sph_2}",@payment.bill_id]
            @taska.save
            flash[:notice] = "Bills created successfully and SMS send to #{@kid.sph_1}#{@kid.sph_2}"
          else
            flash[:danger] = "Insufficient credit. SMS not send to second phone number. Please reload"
          end
        end
      end
      
      redirect_to classroom_path(@kid.classroom)
    else
      flash[:danger] = "Bills creation failed. Please try again"
      redirect_to got_bill_path(taska: @kid.classroom.taska,
                                child: @kid,
                                classroom: @kid.classroom)
    end
    



    #if child ada satu bill, pergi search bill, if more, pergi view bill
    # redirect_to view_bill_path(params[:id] = "#{params[:payment][:taska_id]}",
    #                               "utf8"=>"✓", 
    #                               kid: "#{params[:payment][:kid_id]}",
    #                               month: "#{params[:payment][:month]}", 
    #                               year: "#{params[:payment][:year]}", 
    #                               taska_id: "#{params[:payment][:taska_id]}", 
    #                               "button"=>""), :method => :get
  end

  def create_bill_booking
    @taska = Taska.find(params[:taska_id])
    @kid = Kid.find(params[:kid_id])

    url_bill = "#{ENV['BILLPLZ_API']}bills"
    @payment = Payment.new
     data_billplz = HTTParty.post(url_bill.to_str,
                      :body  => { :collection_id => "#{@taska.collection_id}", 
                      :email=> "#{@taska.email}",
                      :name=> "#{@taska.name}", 
                      :amount=>  @taska.booking*100,
                      :callback_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                      :redirect_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                      :description=>"PLEASE PAY BOOKING FEE TO COMPLETE REGISTRATION" }.to_json, 
                      #:callback_url=>  "YOUR RETURN URL"}.to_json,
            :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
      data = JSON.parse(data_billplz.to_s)
      #render json: data_billplz and return
      if (data["id"].present?)
        @payment.name = "TASKA BOOKING"
        @payment.amount = data["amount"].to_f/100
        @payment.description = data["description"]
        @payment.bill_month = Time.now.in_time_zone('Singapore').month
        @payment.bill_year = Time.now.in_time_zone('Singapore').year
        @payment.taska_id = @taska.id
        @payment.kid_id = @kid.id
        @payment.state = data["state"]
        @payment.paid = data["paid"]
        @payment.bill_id = data["id"]
        @payment.save
        kb = KidBill.create(kid_id: @kid.id, payment_id: @payment.id)
        # start send sms to parents
        @client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_KEY"])
        @client.messages.create(
          to: "+6#{@kid.ph_1}#{@kid.ph_2}",
          from: ENV["TWILIO_PHONE_NO"],
          body: "Bill for booking fee from #{@taska.name} . Please click at this link <#{bill_view_url(payment: @payment.id, kid: @kid.id, taska: @kid.taska.id)}> to complete registration"
        )
        flash[:success] = "Sign Up for #{@kid.name.upcase} completed. Please pay the booking fee of RM #{@payment.amount} to complete."
        redirect_to bill_view_path(payment: @payment.id, kid: @kid.id, taska: @kid.taska.id)
      else
        flash[:danger] = "Sign Up failed. Please try again"
        redirect_to parent_index_path
      end
      
  end

  def bill_taska_monthly #create bill for all taska
    if params[:pwd] == "kidcare@123"
      ctr = 0
      if Rails.env.production?
        taska_all = Taska.all.where.not(id: [5, 9, 1, 44, 45, 4, 48])
      else
        taska_all = Taska.all
      end
      taska_all.each do |taska|
        @taska = Taska.find(taska.id)
        kid_count = @taska.kids.where.not(classroom_id: nil).count
        bill_plan = @taska.payments.where(name: "TASKA PLAN")
        period = Time.now + 1.months
        if (!bill_plan.where(bill_month: period.in_time_zone('Singapore').month).where(bill_year: period.in_time_zone('Singapore').year).present?) && (!bill_plan.where(paid: false).present?) && (kid_count > 0)
        #if 1==1
          if (plan=@taska.plan) == "PAY PER USE"
            real = (kid_count*2.8)*100
            amount = (real*(@taska.discount)).round(1)
            desc = "(#{kid_count} CHILDRENS)"
          elsif (plan=@taska.plan) == "PAY PER USE N"
            real = (kid_count*3)*100
            amount = (real*(@taska.discount)).round(1)
            desc = "(#{kid_count} CHILDRENS)"
          else
            real = $package_price[plan].to_f*100
            amount = real*(@taska.discount)
          end
          #expire = $my_time + 12.months
          url_bill = "#{ENV['BILLPLZ_API']}bills"
          @payment = Payment.new
          data_billplz = HTTParty.post(url_bill.to_str,
                            :body  => { :collection_id => "#{ENV['COLLECTION_ID']}", 
                            :email=> "#{@taska.email}",
                            :name=> "#{@taska.name}", 
                            :amount=>  amount,
                            :callback_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                            :redirect_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                            :description=>"#{@taska.name}'s BILL FOR #{$month_name[period.month]} #{period.year} #{desc}" }.to_json, 
                            #:callback_url=>  "YOUR RETURN URL"}.to_json,
                  :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
                  :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
          data = JSON.parse(data_billplz.to_s)
          #render json: data_billplz and return
          if (data["id"].present?)
            @payment.name = "TASKA PLAN"
            @payment.amount = data["amount"].to_f/100
            @payment.description = data["description"]
            @payment.bill_month = period.month
            @payment.bill_year = period.year
            @payment.taska_id = @taska.id
            @payment.state = data["state"]
            @payment.paid = data["paid"]
            @payment.bill_id = data["id"]
            @payment.cltid = data["collection_id"]
            if @payment.save
              Tskbill.create(real: real/100, disc: (real*(1-@taska.discount))/100, payment_id: @payment.id)
            end
            ctr = ctr + 1
            if Rails.env.production? && 1==0
              @client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_KEY"])
              @client.messages.create(
                to: "+6#{@taska.phone_1}#{@taska.phone_2}",
                from: ENV["TWILIO_PHONE_NO"],
                body: "[#{@taska.name}] New bill from KidCare for #{$month_name[period.month]}-#{period.year} . Please click at this link <#{view_invoice_taska_url(taska: taska, payment: @payment)}> to make payment. Your account will expire on #{taska.expire.strftime('%d-%^b-%y')}.Thank you for your continous support."
              )
            end
            flash[:notice] = "SUCCESS CREATED FOR #{ctr} TASKAS"
          else
            flash[:danger] = "FAILED FOR #{@taska.name}"
          end
        end
      end  
    end  
  end

  def bill_taska1_monthly #taska create own bill
    @taska = Taska.find(params[:id])
    bill_plan = @taska.payments.where(name: "TASKA PLAN")
    dt = Date.today
    if (a=bill_plan.where(paid: false)).present?
      a.delete_all
    end
    if bill_plan.where(bill_month: dt.month, bill_year: dt.year).present?
      dt = Date.today + 1.months
    end

    if (plan=@taska.plan) == "PAY PER USE"
      kid_count = @taska.kids.where.not(classroom_id: nil).count
      desc = "(#{kid_count} CHILDRENS)"
    else
      kid_count = 1
      desc = ""
    end
    real = kid_count*$package_price[plan].to_f*100
    amount = (real*(@taska.discount)).round(2)

    #expire = $my_time + 12.months
    url_bill = "#{ENV['BILLPLZ_API']}bills"
    @payment = Payment.new
    data_billplz = HTTParty.post(url_bill.to_str,
                        :body  => { :collection_id => "#{ENV['COLLECTION_ID']}", 
                        :email=> "#{@taska.email}",
                        :name=> "#{@taska.name}", 
                        :amount=>  amount,
                        :callback_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                        :redirect_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                        :description=>"#{@taska.name}'s BILL FOR #{$month_name[dt.month.to_i]} #{dt.year} #{desc}" }.to_json, 
                        #:callback_url=>  "YOUR RETURN URL"}.to_json,
              :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
              :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
      data = JSON.parse(data_billplz.to_s)
    #render json: data_billplz and return
    if (data["id"].present?)
      @payment.name = "TASKA PLAN"
      @payment.amount = data["amount"].to_f/100
      @payment.description = data["description"]
      @payment.bill_month = dt.month
      @payment.bill_year = dt.year
      @payment.taska_id = @taska.id
      @payment.state = data["state"]
      @payment.paid = data["paid"]
      @payment.bill_id = data["id"]
      @payment.cltid = data["collection_id"]
      if @payment.save
        Tskbill.create(real: real/100, disc: (real*(1-@taska.discount))/100, payment_id: @payment.id)
      end
      redirect_to view_invoice_taska_path(taska: @taska, payment: @payment)
      #flash[:notice] = "SUCCESS CREATED FOR #{@taska.name}"
    else
      redirect_to taska_path(@taska)
      flash[:danger] = "BILL CREATION FAILED. PLEASE TRY AGAIN"
    end
  end

  def oldbill_taska1_monthly #create bill for one taska
    if params[:pwd] == "kidcare@123"
      @taska = Taska.find(params[:id])
      bill_plan = @taska.payments.where(name: "TASKA PLAN")
      if !bill_plan.where(bill_month: params[:mth].to_i).where(bill_year: params[:yr].to_i).present? && !bill_plan.where(paid: false).present?
      #if 1==1
        if (plan=@taska.plan) == "PAY PER USE"
          kid_count = @taska.kids.where.not(classroom_id: nil).count
          real = (kid_count*2.8)*100
          amount = (real*(@taska.discount)).round(1)
          desc = "(#{kid_count} CHILDRENS)"
        else
          real = $package_price[plan].to_f*100
          amount1 = real*(@taska.discount)
          amount = amount1.to_i
        end
        #expire = $my_time + 12.months
        url_bill = "#{ENV['BILLPLZ_API']}bills"
        @payment = Payment.new
        data_billplz = HTTParty.post(url_bill.to_str,
                            :body  => { :collection_id => "#{ENV['COLLECTION_ID']}", 
                            :email=> "#{@taska.email}",
                            :name=> "#{@taska.name}", 
                            :amount=>  amount,
                            :callback_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                            :redirect_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                            :description=>"#{@taska.name}'s BILL FOR #{$month_name[params[:mth].to_i]} #{params[:yr]} #{desc}" }.to_json, 
                            #:callback_url=>  "YOUR RETURN URL"}.to_json,
                  :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
                  :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
          data = JSON.parse(data_billplz.to_s)
        #render json: data_billplz and return
        if (data["id"].present?)
          @payment.name = "TASKA PLAN"
          @payment.amount = data["amount"].to_f/100
          @payment.description = data["description"]
          @payment.bill_month = params[:mth]
          @payment.bill_year = params[:yr]
          @payment.taska_id = @taska.id
          @payment.state = data["state"]
          @payment.paid = data["paid"]
          @payment.bill_id = data["id"]
          @payment.cltid = data["collection_id"]
          if @payment.save
            Tskbill.create(real: real/100, disc: (real*(1-@taska.discount))/100, payment_id: @payment.id)
          end
          #if 1==1
          if Rails.env.production? && 1==0
            @client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_KEY"])
            @client.messages.create(
              to: "+6#{@taska.phone_1}#{@taska.phone_2}",
              from: ENV["TWILIO_PHONE_NO"],
              body: "[#{@taska.name}] New bill from KidCare for #{$month_name[params[:mth].to_i]}-#{params[:yr]} . Please click at this link <#{view_invoice_taska_url(taska: @taska, payment: @payment)}> to make payment. Your account will expire on #{@taska.expire.strftime('%d-%^b-%y')}. Thank you for your continous support."
            )
          end
          flash[:notice] = "SUCCESS CREATED FOR #{@taska.name}"
        else
          flash[:danger] = "FAILED FOR #{@taska.name}"
        end
      end  
    end  
  end

  def create_bill_taska
    @taska = Taska.find(params[:id])
    amount = ($package_price["#{@taska.plan}"].to_f*100)*(@taska.discount)
    expire = $my_time + 12.months
    url_bill = "#{ENV['BILLPLZ_API']}bills"
    @payment = Payment.new
     data_billplz = HTTParty.post(url_bill.to_str,
                      :body  => { :collection_id => "#{ENV['COLLECTION_ID']}", 
                      :email=> "#{@taska.email}",
                      :name=> "#{@taska.name}", 
                      :amount=>  amount,
                      :callback_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                      :redirect_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                      :description=>"#{@taska.name}'s BILL FOR #{$month_name[$my_time.month + 1]} #{$my_time.year}" }.to_json, 
                      #:callback_url=>  "YOUR RETURN URL"}.to_json,
            :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
      data = JSON.parse(data_billplz.to_s)
      #render json: data_billplz and return
      if (data["id"].present?)
        @payment.name = "TASKA PLAN"
        @payment.amount = data["amount"].to_f/100
        @payment.description = data["description"]
        first_date = $my_time + 1.months
        @payment.bill_month = $my_time.month
        @payment.bill_year = $my_time.year
        @payment.taska_id = @taska.id
        @payment.state = data["state"]
        @payment.paid = data["paid"]
        @payment.bill_id = data["id"]
        @payment.save
        redirect_to admin_index_path
      else
        flash[:danger] = "Sign Up failed. Please try again"
        redirect_to admin_index_path
      end
      
  end

  def teacher_create_bill
    
    @teacher = Teacher.find(params[:id])
    @course = Course.find(params[:course])
    @college = @course.college
    amount = @course.base_fee.to_f*100
    url_bill = "#{ENV['BILLPLZ_API']}bills"
    if (params[:plan] == "plan1")
      @payment = Payment.new
      data_billplz = HTTParty.post(url_bill.to_str,
                      :body  => { :collection_id => "#{@college.collection_id}", 
                      :email=> "#{@teacher.email}",
                      :name=> "#{@teacher.username}", 
                      :amount=>  amount,
                      :callback_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                      :redirect_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                      :description=>"#{@teacher.tchdetail.name}'s bill for #{@course.name}"}.to_json, 
                      #:callback_url=>  "YOUR RETURN URL"}.to_json,
            :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
      data = JSON.parse(data_billplz.to_s)
      #render json: data_billplz and return

      if (data["id"].present?)
        @payment.amount = data["amount"].to_f/100
        @payment.description = data["description"]
        @payment.bill_month = Time.now.in_time_zone('Singapore').month
        @payment.bill_year = Time.now.in_time_zone('Singapore').year
        @payment.course_id = @course.id
        @payment.teacher_id = @teacher.id
        @payment.state = data["state"]
        @payment.paid = data["paid"]
        @payment.bill_id = data["id"]
        @payment.save
      else
        flash[:danger] = "Sign Up failed. Please try again"
        redirect_to root_path and return
      end
      
    else
      (1..3).each do |i|
        @payment = Payment.new
        data_billplz = HTTParty.post(url_bill.to_str,
                      :body  => { :collection_id => "#{@college.collection_id}", 
                      :email=> "#{@teacher.email}",
                      :name=> "#{@teacher.username}", 
                      :amount=>  amount/3,
                      :callback_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                      :redirect_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                      :description=>"Cuba Bill for Teacher #{i}"}.to_json, 
                      #:callback_url=>  "YOUR RETURN URL"}.to_json,
            :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
        data = JSON.parse(data_billplz.to_s)
        if (data["id"].present?)
            @payment.amount = data["amount"].to_f/100
            @payment.description = data["description"]
            @payment.bill_month = Time.now.in_time_zone('Singapore').month
            @payment.bill_year = Time.now.in_time_zone('Singapore').year
            @payment.course_id = @course.id
            @payment.teacher_id = @teacher.id
            @payment.state = data["state"]
            @payment.paid = data["paid"]
            @payment.bill_id = data["id"]
            @payment.save
        else
            flash[:danger] = "Sign Up failed. Please try again"
            redirect_to root_path and return
        end
      end
      #redirect_to teacher_index_path
    end
    redirect_to payment_signup_path(@teacher, college_id: @college.id, course_id: @course.id)
  end

  def view_bill_old
    @kid = Kid.find(params[:kid])
    @kid_bills = @kid.payments.where(bill_month: params[:month], bill_year: params[:year])
  end

  def destroy
    @payment = Payment.find(params[:id])
    # addtn = @payment.addtns
    # kb = @payment.kid_bills
    # otk = @payment.otkids
    @taska = @payment.taska
    if params[:kid_id].present?
      @kid = Kid.find(params[:kid_id])
    end
    #@classroom = @kid.classroom
    url_bill = "#{ENV['BILLPLZ_API']}bills/#{@payment.bill_id}"
    
    data_billplz = HTTParty.delete(url_bill.to_str,
                                  :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
                                  :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
    # addtn.delete_all unless addtn.blank?
    # kb.delete_all unless kb.blank?
    # otk.delete_all unless otk.blank?
    @payment.destroy
    
    #render json: data_billplz and return
    flash[:notice] = "Bills was successfully deleted"
    if params[:index].present?
      redirect_to unpaid_index_path(@taska)
    elsif params[:account].present?
      redirect_to bill_account_path(month: params[:month], 
                                    year: params[:year],
                                    paid: params[:paid],
                                    id: params[:taska])
    elsif params[:gotb].present?
      redirect_to got_bill_path(taska: @kid.classroom.taska.id,
                                child: @kid.id,
                                classroom: @kid.classroom)
    else
      redirect_to all_bills_taska_path(id: @taska.id, kid_id: @kid.id)
    end
  end

  def create_billplz_bank
    @taska = Taska.find(params[:id])
    url_bill = "#{ENV['BILLPLZ_API']}check/bank_account_number/#{@taska.acc_no}"
    data_billplz = HTTParty.get(url_bill.to_str,
            :body  => { }.to_json, 
                        #:callback_url=>  "YOUR RETURN URL"}.to_json,
            :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
    #render json: data_billplz and return
    data = JSON.parse(data_billplz.to_s)
    if data["name"] == "verified"
      @taska_same = Taska.where.not(id: @taska.id).where(acc_no: "#{@taska.acc_no}").first
      if @taska_same.present?
        @taska.collection_id = @taska_same.collection_id
        @taska.bank_status = "verified"
        @taska.billplz_reg = "SAME AS #{@taska_same.name}(id:#{@taska_same.id})"
        @taska.save
        redirect_to create_bill_taska_path(id: @taska)
      else
        flash[:danger] = "Bank Account not available. Please use other accounts"
        redirect_to update_bank_path(@taska)
      end
    else
      url_bill = "#{ENV['BILLPLZ_API']}bank_verification_services/"
      data_billplz = HTTParty.post(url_bill.to_str,
              :body  => { :name => "#{@taska.acc_name}",
                          :id_no => "#{@taska.ssm_no}",
                          :acc_no => "#{@taska.acc_no}",
                          :code => "#{$bank_code["#{@taska.bank_name}"]}",
                          :organization => true }.to_json, 
                          #:callback_url=>  "YOUR RETURN URL"}.to_json,
              :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
              :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
      #render json: data_billplz and return
      data = JSON.parse(data_billplz.to_s)
      if data["status"].present?
        @taska.bank_status = data["status"]
        @taska.billplz_reg = "NO"
        @taska.save
        redirect_to create_bill_taska_path(id: @taska)
      else
        flash[:danger] = "Bank Account Not Valid. Please update"
        redirect_to update_bank_path(@taska)
      end
    end
  end

  def update_billplz_bank
    url_bill = "#{ENV['BILLPLZ_API_REAL']}check/bank_account_number/562106690784"
      data_billplz = HTTParty.get(url_bill.to_str,
              :body  => { }.to_json, 
                          #:callback_url=>  "YOUR RETURN URL"}.to_json,
              :basic_auth => { :username => "#{ENV['BILLPLZ_APIKEY_REAL']}" },
              :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
      render json: data_billplz and return
  end

  def create_billplz_try
    url_bill = "https://www.billplz.com/api/v3/check/bank_account_number/562254511778"
    data_billplz = HTTParty.get(url_bill.to_str,
            :body  => { }.to_json, 
                        #:callback_url=>  "YOUR RETURN URL"}.to_json,
            :basic_auth => { :username => "68abd407-b8c7-4bee-9e16-620a578b2a48" },
            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
    # url_bill = "https://www.billplz.com/api/v3/bank_verification_services"
    # data_billplz = HTTParty.post(url_bill.to_str,
    #         :body  => { :name => "WMA MAJU VENTURES",
    #                     :id_no => "002333391P",
    #                     :acc_no => "564258576740",
    #                     :code => "MBBEMYKL",
    #                     :organization => true }.to_json, 
    #                     #:callback_url=>  "YOUR RETURN URL"}.to_json,
    #         :basic_auth => { :username => "68abd407-b8c7-4bee-9e16-620a578b2a48" },
    #         :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
    render json: data_billplz and return
  end



  private
  def set_all
    @teacher = current_teacher
    @parent = current_parent
    @admin = current_admin
    if @admin.present?
      @spv = @admin.spv
    end  
    @owner = current_owner
  end
  



end

# #EXAMPLE WORKING CONTROLLERS

#   def create_temp
    
    
#     url_bill = 'https://www.billplz.com/api/v3/bills'
#     api_key = '68abd407-b8c7-4bee-9e16-620a578b2a48'
#     data_billplz = HTTParty.post(url_bill.to_str,
#             :body  => { :collection_id => "#{@taska.collection_id}", 
#                         :email=> "#{@kid.parent.email}",
#                         :name=> "#{@kid.name}", 
#                         :amount=>  260,
#                         :callback_url=> "#{ENV['ROOT_URL_BILLPLZ']}taska/#{params[:id]}/new_bill",
#                         :description=>"First Bills from Rails"}.to_json, 
#                         #:callback_url=>  "YOUR RETURN URL"}.to_json,
#             :basic_auth => { :username => api_key },
#             :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
#     render json: data_billplz
#   end

  

#   def create_bill_old
#     url_bill = 'https://www.billplz.com/api/v3/bills'
#     api_key = '68abd407-b8c7-4bee-9e16-620a578b2a48'
#     @taska = Taska.find(params[:id])
#     @bill = HTTParty.post(url_bill.to_str,
#             :body  => { :collection_id => "#{@taska.collection_id}", 
#                         :email=> "email@gmail.com",
#                         :name=> "John Smith", 
#                         :amount=>  260,
#                         :callback_url=> "#{ENV['ROOT_URL_BILLPLZ']}taska/#{params[:id]}/create_bill",
#                         :description=>"First Bills from Rails"}.to_json, 
#                         #:callback_url=>  "YOUR RETURN URL"}.to_json,
#             :basic_auth => { :username => api_key },
#             :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
#     render json: @bill
#   end


#   def index_eg #working 1
#     url_collection = 'https://www.billplz.com/api/v3/collections/wyjwzbvz'
#     api_key = '68abd407-b8c7-4bee-9e16-620a578b2a48'
#     #GET COLLECTION
#     billplz = HTTParty.get(url_collection.to_str,
#                   :basic_auth => { :username => api_key },
#                   :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).body
#     #render json: data
#     @data = JSON.parse(billplz)


   
#       @collection = Payment.new
#       @collection.collection_id = @data["id"]
#       @collection.collection_name = @data["title"]
#       #@collection.save
#    #data = JSON.parse(data_billplz)
    
#     @collection = Payment.new
#       @collection.collection_id = @data["id"]
#       @collection.collection_name = @data["title"]



  

#      #@collection.collection_name = "data"=>"title"
#   end

#   def create_collection_eg #working 2
#     url_collection = 'https://www.billplz.com/api/v3/collections/'
#     api_key = '68abd407-b8c7-4bee-9e16-620a578b2a48'
#     title = "masuk jadi"
#     emails = 'taskasarjanapintar2016@gmail.com'

#     @data_billplz = HTTParty.post(url_collection.to_str,
#                   :body  => { :title => title,
#                               :split_payment => {
#                                 :email => emails, 
#                                 :fixed_cut => 0, 
#                                 :split_header => true}
#                             }.to_json,
#                   :basic_auth => { :username => api_key },
#                   :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
#     #render json: @data_billplz
    


#   end




#   def index_old
#     url_collection = 'https://billplz-staging.herokuapp.com/api/v3/collections'
#     url_bill = 'https://billplz-staging.herokuapp.com/api/v3/bills'
#     url_bill_get = 'https://billplz-staging.herokuapp.com/api/v3/bills/c7w8c7a3'
#     api_key = 'c2b30f37-f5af-407f-9780-4d341ba4f427' #You can get in your billplz setting account
#     title = "Anything to explainn about your bill" 
#     #GET COLLECTION
#     @collection = HTTParty.get(url_collection.to_str,
#                   :body  => { :title => title }.to_json,
#                   :basic_auth => { :username => api_key },
#                   :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
#     #@collection = @collection.to_html
#     @collections = Payment.get_collection

#     #GET BILL
#     @get_bill = HTTParty.get(url_bill_get,
#                :basic_auth => { :username => api_key },
#                :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
#     #CREATE BILL
#     @bill = HTTParty.get(url_bill.to_str,
#             :body  => { :collection_id => @collection.parsed_response["id"], :email=> "email@gmail.com", :name=> "John Smith", :amount=>  "260", :callback_url=>  "YOUR RETURN URL"}.to_json,
#             :basic_auth => { :username => api_key },
#             :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
        
#     #redirect_to @collection.parsed_response["url"]
#   end




#   def get_bill
#     url_bill_get = 'https://billplz-staging.herokuapp.com/api/v3/bills/c7w8c7a3'
#     api_key = 'c2b30f37-f5af-407f-9780-4d341ba4f427' #You can get the secret key in your billplz's setting account
    
#     @get_bill = HTTParty.get(url_bill,
#                :basic_auth => { :username => api_key },
#                :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
#     @paid = @get_bill.parsed_response["paid"]
#     #others data you can check at billplz api
#   end



















