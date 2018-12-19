class PaymentsController < ApplicationController
  require 'json'
  #ENV['BILLPLZ_API'] = "https://billplz-staging.herokuapp.com/api/v3/"
  #ENV['BILLPLZ_URL'] = "https://billplz-staging.herokuapp.com/"
  #ENV['BILLPLZ_APIKEY'] = "6d78d9dd-81ac-4932-981b-75e9004a4f11"
  before_action :set_all
 

  def index
    @taska = Taska.find(params[:id])
  end

  def update
    @bill = Payment.where(bill_id: "#{params[:billplz][:id]}").first
    if @bill.present?
    #@kid = @bill.kid
      @bill.paid = params[:billplz][:paid]
      @bill.save
      if @bill.paid
        flash[:success] = "Bill was successfully paid. Please download the receipt"
      else
        flash[:danger] = "Bill was not paid due to bank rejection. Please try again"
      end
      if (@bill.kids.present?)
        @parent = @bill.parent
        redirect_to my_kid_path(id: @parent.id)
      elsif (@bill.teacher.present?)
        redirect_to course_payment_pdf_path(payment: @bill.id, format: :pdf)
      elsif (@bill.taska.present?)
        redirect_to taska_path(@bill.taska.id)
      end
    end
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

  def new
    @classroom = Classroom.find(params[:classroom])
    @taska = @classroom.taska
    @kid = Kid.find(params[:child])

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
    render action: "new", layout: "dsb-admin-classroom" 
  end

  def create
    params.require(:payment).permit(:amount, :description, :month, :year, :kid_id, :taska_id)
    amount = params[:payment][:amount].to_f*100
    @payment = Payment.new
    @taska = Taska.find(params[:payment][:taska_id])
    @kid = Kid.find(params[:payment][:kid_id])
    url_bill = "#{ENV['BILLPLZ_API']}bills"
    data_billplz = HTTParty.post(url_bill.to_str,
            :body  => { :collection_id => "#{@taska.collection_id}", 
                        :email=> "#{@kid.parent.email}",
                        :name=> "#{@kid.name}", 
                        :amount=>  amount,
                        :callback_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                        :redirect_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                        :description=>"#{params[:payment][:description]}"}.to_json, 
                        #:callback_url=>  "YOUR RETURN URL"}.to_json,
            :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
    #render json: data_billplz
    data = JSON.parse(data_billplz.to_s)
    if data["id"].present?
      @payment.amount = params[:payment][:amount].to_f
      @payment.description = params[:payment][:description]
      @payment.bill_month = params[:payment][:month]
      @payment.bill_year = params[:payment][:year]
      
      @payment.parent_id = @kid.parent.id
      @payment.taska_id = @kid.classroom.taska.id
      @payment.state = data["state"]
      @payment.paid = data["paid"]
      @payment.bill_id = data["id"]
      @payment.name = "KID BILL"
      @payment.save
      KidBill.create(kid_id: @kid.id, payment_id: @payment.id)
      if @kid.beradik.count > 0
        @kid.beradik.each do |beradik|
          KidBill.create(kid_id: beradik.id, payment_id: @payment.id)
        end
      end
      flash[:success] = "Bills created successfully"
    else
      flash[:danger] = "Bills creation failed. Please try again"
    end
    redirect_to classroom_path(@kid.classroom)



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
                      :description=>"#{@taska.name.upcase}'S BOOKING FOR #{@kid.name.upcase}" }.to_json, 
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
        flash[:success] = "Sign Up for #{@kid.name.upcase} completed. Please pay the booking fee of RM #{@payment.amount} to complete."
        redirect_to parent_index_path
      else
        flash[:danger] = "Sign Up failed. Please try again"
        redirect_to parent_index_path
      end
      
  end

  def create_bill_taska
    @taska = Taska.find(params[:id])

    if @taska.plan == "taska_basic"
      amount = 360.to_f*100
      today = Time.now.in_time_zone('Singapore')
      expire = today + 3.months
    elsif @taska.plan == "taska_standard"
      amount = 500.to_f*100
      today = Time.now.in_time_zone('Singapore')
      expire = today + 6.months
    elsif @taska.plan == "taska_premium"
      amount = 860.to_f*100
      today = Time.now.in_time_zone('Singapore')
      expire = today + 12.months
    end
    url_bill = "#{ENV['BILLPLZ_API']}bills"
    @payment = Payment.new
     data_billplz = HTTParty.post(url_bill.to_str,
                      :body  => { :collection_id => "#{ENV['COLLECTION_ID']}", 
                      :email=> "#{@taska.email}",
                      :name=> "#{@taska.name}", 
                      :amount=>  amount,
                      :callback_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                      :redirect_url=> "#{ENV['ROOT_URL_BILLPLZ']}payments/update",
                      :description=>"#{@taska.name}'s bill for #{@taska.plan.upcase} plan (valid from #{today.strftime("%d %b, %Y")} to #{expire.strftime("%d %b, %Y")})" }.to_json, 
                      #:callback_url=>  "YOUR RETURN URL"}.to_json,
            :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
      data = JSON.parse(data_billplz.to_s)
      #render json: data_billplz and return
      if (data["id"].present?)
        @payment.name = "TASKA PLAN"
        @payment.amount = data["amount"].to_f/100
        @payment.description = data["description"]
        @payment.bill_month = Time.now.in_time_zone('Singapore').month
        @payment.bill_year = Time.now.in_time_zone('Singapore').year
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

  def view_bill
    @kid = Kid.find(params[:kid])
    @kid_bills = @kid.payments.where(bill_month: params[:month], bill_year: params[:year])
  end

  def destroy
    @payment = Payment.find(params[:id])
    @taska = @payment.taska
    @kid = @payment.kid
    @classroom = @kid.classroom
    url_bill = "#{ENV['BILLPLZ_API']}bills/#{@payment.bill_id}"
    
    data_billplz = HTTParty.delete(url_bill.to_str,
                                  :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
                                  :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
    @payment.destroy
    #render json: data_billplz and return
    flash[:notice] = "Bills was successfully deleted for #{@kid.name.upcase}"
    if params[:index].present?
      redirect_to unpaid_index_path(@taska)
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
    url_bill = "#{ENV['BILLPLZ_API']}bank_verification_services/7026223147"
    data_billplz = HTTParty.get(url_bill.to_str,
            :body  => { }.to_json, 
                        #:callback_url=>  "YOUR RETURN URL"}.to_json,
            :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
    render json: data_billplz
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



















