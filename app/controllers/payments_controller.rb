class PaymentsController < ApplicationController
  require 'json'
  #$billplz_url = "https://billplz-staging.herokuapp.com/api/v3/"
  #$billplz = "https://billplz-staging.herokuapp.com/"
  #$api_key = "6d78d9dd-81ac-4932-981b-75e9004a4f11"
 

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
      flash[:success] = "Bill was successfully paid"
    else
      flash[:danger] = "Bill was not paid due to bank rejection. Please try again"
    end
    if (@bill.kid.present?)
      @kid = @bill.kid
      redirect_to parent_index_path
    elsif (@bill.teacher.present?)
      redirect_to teacher_pay_bill_path(id: @bill.teacher.id, course_id: @bill.course.id)
    end
   end
   

  end

  def create_collection
    @taska = Taska.find(params[:id])
    url_collection = "#{$billplz_url}collections/"
    title = @taska.name
    emails = @taska.email

    data_billplz = HTTParty.post(url_collection.to_str,
                  :body  => { :title => title,
                              :split_payment => {
                                :email => emails, 
                                :fixed_cut => 0, 
                                :split_header => true}
                            }.to_json,
                  :basic_auth => { :username => $api_key },
                  :headers => { 'Content-Type' => 'application/json', 
                                'Accept' => 'application/json' })
    data = JSON.parse(data_billplz.to_s)
    @taska.collection_id = data["id"]
    @taska.save
    redirect_to payment_index_path(@taska)
  end



  def search_bill
    @taska = Taska.find(params[:taska_id])
    @taska_classrooms = @taska.classrooms
    @month = params[:month]
    @year = params[:year]
    #redirect_to display_children_path(@taska_classrooms)
  end

  def new
    @taska = Taska.find(params[:id])
    @kid = Kid.find(params[:child])
    @payment = Payment.new
  end

  def create
    params.require(:payment).permit(:amount, :description, :month, :year, :kid_id, :taska_id)
    amount = params[:payment][:amount].to_f*100
    @payment = Payment.new
    @taska = Taska.find(params[:payment][:taska_id])
    @kid = Kid.find(params[:payment][:kid_id])
    url_bill = "#{$billplz_url}bills"
    data_billplz = HTTParty.post(url_bill.to_str,
            :body  => { :collection_id => "#{@taska.collection_id}", 
                        :email=> "#{@kid.parent.email}",
                        :name=> "#{@kid.name}", 
                        :amount=>  amount,
                        :callback_url=> "http://localhost:3000/payments/update",
                        :redirect_url=> "http://localhost:3000/payments/update",
                        :description=>"#{params[:payment][:description]}"}.to_json, 
                        #:callback_url=>  "YOUR RETURN URL"}.to_json,
            :basic_auth => { :username => $api_key },
            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
    #render json: data_billplz
    data = JSON.parse(data_billplz.to_s)
    @payment.amount = params[:payment][:amount].to_f
    @payment.description = params[:payment][:description]
    @payment.bill_month = params[:payment][:month]
    @payment.bill_year = params[:payment][:year]
    @payment.kid_id = params[:payment][:kid_id]
    @payment.parent_id = @kid.parent.id
    @payment.taska_id = @kid.classroom.taska.id
    @payment.state = data["state"]
    @payment.paid = data["paid"]
    @payment.bill_id = data["id"]
    @payment.save
    #if child ada satu bill, pergi search bill, if more, pergi view bill
    redirect_to view_bill_path(params[:id] = "#{params[:payment][:taska_id]}",
                                  "utf8"=>"✓", 
                                  kid: "#{params[:payment][:kid_id]}",
                                  month: "#{params[:payment][:month]}", 
                                  year: "#{params[:payment][:year]}", 
                                  taska_id: "#{params[:payment][:taska_id]}", 
                                  "button"=>""), :method => :get
  end

  def teacher_create_bill
    
    @teacher = Teacher.find(params[:id])
    @course = Course.find(params[:course])
    @college = @course.college
    amount = @course.base_fee.to_f*100
    url_bill = "#{$billplz_url}bills"
    if (params[:plan] == "plan1")
      @payment = Payment.new
      data_billplz = HTTParty.post(url_bill.to_str,
                      :body  => { :collection_id => "#{@college.collection_id}", 
                      :email=> "#{@teacher.email}",
                      :name=> "#{@teacher.username}", 
                      :amount=>  amount,
                      :callback_url=> "http://localhost:3000/payments/update",
                      :redirect_url=> "http://localhost:3000/payments/update",
                      :description=>"Cuba Bill for Teacher"}.to_json, 
                      #:callback_url=>  "YOUR RETURN URL"}.to_json,
            :basic_auth => { :username => $api_key },
            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
      data = JSON.parse(data_billplz.to_s)

      if (data["id"].present?)
        @payment.amount = data["amount"].to_f/100
        @payment.description = data["description"]
        @payment.bill_month = Date.today.month
        @payment.bill_year = Date.today.year
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
                      :callback_url=> "http://localhost:3000/payments/update",
                      :redirect_url=> "http://localhost:3000/payments/update",
                      :description=>"Cuba Bill for Teacher #{i}"}.to_json, 
                      #:callback_url=>  "YOUR RETURN URL"}.to_json,
            :basic_auth => { :username => $api_key },
            :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
        data = JSON.parse(data_billplz.to_s)
        if (data["id"].present?)
            @payment.amount = data["amount"].to_f/100
            @payment.description = data["description"]
            @payment.bill_month = Date.today.month
            @payment.bill_year = Date.today.year
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
    url_bill = "#{$billplz_url}bills/#{params[:bill_id]}"
    @payment = Payment.find(params[:bill])
    data_billplz = HTTParty.delete(url_bill.to_str,
                                  :basic_auth => { :username => $api_key },
                                  :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
    @payment.destroy
    flash[:notice] = "Bills was successfully deleted"
    redirect_to view_bill_path(params[:taska],
                                  "utf8"=>"✓", 
                                  kid: "#{params[:kid]}",
                                  month: "#{params[:month]}", 
                                  year: "#{params[:year]}", 
                                  "button"=>""), :method => :get
  end



  private
  



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
#                         :callback_url=> "http://localhost:3000/taska/#{params[:id]}/new_bill",
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
#                         :callback_url=> "http://localhost:3000/taska/#{params[:id]}/create_bill",
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



















