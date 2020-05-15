#IMPORTANT TO CHANGE
@taska = Taska.find(3)
all_month = [[6,2020]]
#END CHANGE

classrooms = @taska.classrooms
arr_em = []
arr_not_em =[]
arr_ph = []
arr_not_ph = []

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


no_bill = no_bill + 1

end # end Data ID
sleep 0.2
end #End pmt not exist

end #end loop month

#SEND EMAIL
if em.present? && no_bill > 0

mail = SendGrid::Mail.new
mail.from = SendGrid::Email.new(email: 'billing@kota.my', name: "#{@taska.name}")
mail.subject = "NEW BILL FOR: NO #{cls.description} #{cls.classroom_name}"
#Personalisation, add cc
personalization = SendGrid::Personalization.new
em = "billing123@kota.my" unless em.present?
personalization.add_to(SendGrid::Email.new(email: "#{em}"))
#personalization.add_cc(SendGrid::Email.new(email: "#{@taska.email}"))
mail.add_personalization(personalization)
#add content
msg = "<html>
<body>
Dear Mr/Mrs <strong>#{nm}</strong><br><br>


Your new bill from <strong>#{@taska.name}</strong> is ready. <br><br>

Please click <a href=https://www.kota.my/list_bill?cls=#{cls.unq}>HERE</a> to view and make payment. <br><br>

<strong>Taman Kita Tanggungjawab Bersama</strong>.<br><br>

Powered by <strong>www.kota.my</strong>
</body>
</html>"
#sending email
mail.add_content(SendGrid::Content.new(type: 'text/html', value: "#{msg}"))
sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])
@response = sg.client.mail._('send').post(request_body: mail.to_json)
arr_em << ["#{cls.description} #{cls.classroom_name}",em] unless @response.status_code != "202"
arr_not_em << ["#{cls.description} #{cls.classroom_name}",em,@response.status_code] unless @response.status_code == "202"
end #END send email

#SEND SMS
if ph.present? && no_bill > 0
url = "https://sms.360.my/gw/bulk360/v1.4?"
usr = "user=admin@kidcare.my&"
ps = "pass=#{ENV['SMS360']}&"
to = "to=6#{ph}&"
txt = "text=New Bill fr #{@taska.name}.\n Click https://www.kota.my/list_bill?cls=#{cls.unq} to pay. TAMAN KITA TANGGUNGJAWAB BERSAMA."

fixie = URI.parse "http://fixie:2lSaDRfniJz8lOS@velodrome.usefixie.com:80"
data_sms = HTTParty.get(
"#{url}#{usr}#{ps}#{to}#{txt}",
http_proxyaddr: fixie.host,
http_proxyport: fixie.port,
http_proxyuser: fixie.user,
http_proxypass: fixie.password
)
arr_ph << ["#{cls.description} #{cls.classroom_name}",ph] unless data_sms.parsed_response[0..2] != "200"
arr_not_ph << ["#{cls.description} #{cls.classroom_name}",ph,data_sms.parsed_response[0..2]] unless data_sms.parsed_response[0..2] == "200"
end #end sms


sleep 0.2
end # end classroom
