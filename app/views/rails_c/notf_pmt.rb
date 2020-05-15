arr_pmt = ["jdshj",[32,56,66]]

mail = SendGrid::Mail.new
mail.from = SendGrid::Email.new(email: 'billing@kota.my', name: "{@taska.name}")
mail.subject = "Payment Notification from {cls.name cls.desc}"
#Personalisation, add cc
personalization = SendGrid::Personalization.new
em = "billing123@kota.my" unless em.present?
personalization.add_to(SendGrid::Email.new(email: "mmnr00@gmail.com"))
personalization.add_to(SendGrid::Email.new(email: "mustakhim.rehan@gmail.com"))
#personalization.add_cc(SendGrid::Email.new(email: "#{@taska.email}"))
mail.add_personalization(personalization)

#loop thru arr_pmt
list_bill = ""
tot_bill = 0.00
arr_pmt[1].each do |n|
	list_bill = list_bill + "<li>RM #{n}</li>"
	tot_bill = tot_bill + n
end


#add content
msg = "<html>
<body>
Bill List as below:
<ul>
#{list_bill}
</ul>

Total Payment Received: <b>RM #{tot_bill}</b><br>

Click here to confirm status in payment gateway. <br><br>

Taman Kita Tanggungjawab Bersama

</html>"
#sending email
mail.add_content(SendGrid::Content.new(type: 'text/html', value: "#{msg}"))
sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])
@response = sg.client.mail._('send').post(request_body: mail.to_json)
