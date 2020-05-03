@taska = Taska.find(3)
classrooms = @taska.classrooms
# get months and year
all_month = [[1,2020],[2,2020]]

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

end # end classroom
