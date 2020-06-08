#IMPORTANT TO CHANGE
@taska = Taska.find(2)
all_month = [[7,2021],[8,2021],[9,2021]]
#END CHANGE

classrooms = @taska.classrooms

#init for payment
tot = 0.00
no_bill = 0
@taska.bilitm.each do |k,v|
tot = tot + v
end

#create payment for each classrooms
classrooms.each do |cls|
pmt = cls.payments

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

#CREATE PAYMENT
if 1==1 #data["id"].present?
@payment = Payment.new
@payment.amount = tot
@payment.description = "Bill for #{$month_name[m[0]]}-#{m[1]}"
@payment.bill_month = m[0]
@payment.bill_year = m[1]
@payment.taska_id = @taska.id
@payment.classroom_id = cls.id
@payment.state = "due"
@payment.paid = false
unq = (0...6).map { ('A'..'Z').to_a[rand(26)] }.join
while Payment.where(bill_id: unq).present?
unq = (0...6).map { ('A'..'Z').to_a[rand(26)] }.join
end
@payment.bill_id = unq
@payment.reminder = false
@payment.name = "RSD M BILL"
@payment.cltid = @taska.collection_id
@payment.save

#Create KidBill
KidBill.create(payment_id: @payment.id,
extra: [nm,ph,em], 
extradtl: @taska.bilitm,
clsname: "#{cls.description} #{cls.classroom_name}"
)


no_bill = no_bill + 1

end # end Data ID

end #End pmt not exist

end #end loop month

end # end classroom

#SEND EMAIL
#add content
msg = "<html>
<body>
Dear Admins for <strong>#{@taska.name}</strong>,<br><br>


Please be informed that <strong>#{no_bill} Bills</strong> have been created for 
<strong>#{$month_name[all_month[0][0]]}-#{all_month[0][1]}.</strong>
<br><br>

Email and SMS notification to all residents will be sent in <strong>24 hours.</strong> 
<br><br>

<strong>Taman Kita Tanggungjawab Bersama</strong>.<br><br>

Powered by <strong>www.kota.my</strong>
</body>
</html>"
#sending email
mail = SendGrid::Mail.new
mail.from = SendGrid::Email.new(email: 'billing@kota.my', name: "www.kota.my")
mail.subject = "NEW BILLS CREATION NOTIFICATION FOR #{@taska.name}"
#Personalisation, add cc
personalization = SendGrid::Personalization.new

@taska.admins.each do |adm|
personalization.add_to(SendGrid::Email.new(email: "#{adm.email}"))
end

personalization.add_bcc(SendGrid::Email.new(email: "admin@kidcare.my"))
personalization.add_bcc(SendGrid::Email.new(email: "simplysolutionplt@gmail.com"))

mail.add_personalization(personalization)
mail.add_content(SendGrid::Content.new(type: 'text/html', value: "#{msg}"))
sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])
#@response = sg.client.mail._('send').post(request_body: mail.to_json)







