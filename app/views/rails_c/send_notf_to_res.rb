#IMPORTANT TO CHANGE
@taska = Taska.find(3)
#END CHANGE

classrooms = @taska.classrooms
arr_em = []
arr_not_em =[]
arr_ph = []
arr_not_ph = []


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


#SEND EMAIL
if em.present?

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
if ph.present?
# url = "https://sms.360.my/gw/bulk360/v1.4?"
# usr = "user=admin@kidcare.my&"
# ps = "pass=#{ENV['SMS360']}&"
# to = "to=whatsapp:6#{ph}&"
# txt = "text=#{@taska.name} : Monthly Fees Notification - Dear Residents, please click https://www.kota.my/list_bill?cls=#{cls.unq} to view and make payment. If you are unable to click the link, please save (add to contact) this number, or reply 'yes' to this message. Thank you for your continuous support - RUSDI B RUSLAN, Pengerusi Persatuan Penduduk Komuniti LEP3"

# fixie = URI.parse "http://fixie:2lSaDRfniJz8lOS@velodrome.usefixie.com:80"
# data_sms = HTTParty.get(
# "#{url}#{usr}#{ps}#{to}#{txt}",
# http_proxyaddr: fixie.host,
# http_proxyport: fixie.port,
# http_proxyuser: fixie.user,
# http_proxypass: fixie.password
# )

puts ph

url = "https://www.isms.com.my/isms_send.php?"
usr = "un=kotamy&"
ps = "pwd=#{ENV['isms']}&"
tp = "type=1&"
trm = "agreedterm=YES"
to = "dstno=6#{ph}&"
txt = "msg=Fee Notification from #{@taska.name} Please click https://www.kota.my/list_bill?cls=#{cls.unq} to make payment.&"
data_sms = HTTParty.get("#{url}#{usr}#{ps}#{to}#{txt}#{tp}#{trm}", timeout: 120)
puts data_sms



#arr_ph << ["#{cls.description} #{cls.classroom_name}",ph] unless data_sms.parsed_response[0..2] != "200"
#arr_not_ph << ["#{cls.description} #{cls.classroom_name}",ph,data_sms.parsed_response[0..2]] unless data_sms.parsed_response[0..2] == "200"
end #end sms


sleep 0.2
end # end classroom
