arr_pmt = ["jdshj",[2568,2654,2601]]

#loop thru arr_pmt
list_bill = ""
tot_bill = 0.00
arr_pmt[1].each do |n|
pym = Payment.find(n)
list_bill = list_bill + 
"<li>
#{pym.description} (#{pym.bill_id}) - RM #{pym.amount}
</li>"
tot_bill = tot_bill + pym.amount
end

#add content
msg = "<html>
<body>
Payment received from <b>{cls.name}</b><br><br>

Bill List as below:
<ul>
#{list_bill}
</ul>



Click <a href= #{ENV["BILLPLZ_URL"]}bills/#{arr_pmt[0]}>here</a> to confirm status in payment gateway. <br><br>

Taman Kita Tanggungjawab Bersama

</body>
</html>"

#sending email
mail = SendGrid::Mail.new
mail.from = SendGrid::Email.new(email: 'billing@kota.my', name: "{@taska.name}")
mail.subject = "Payment Notification from {cls.name cls.desc}"
#Personalisation, add cc
personalization = SendGrid::Personalization.new
em = "billing123@kota.my" unless em.present?
personalization.add_to(SendGrid::Email.new(email: "mmnr00@gmail.com"))
personalization.add_cc(SendGrid::Email.new(email: "mustakhim.rehan@gmail.com"))
#personalization.add_cc(SendGrid::Email.new(email: "#{@taska.email}"))
mail.add_personalization(personalization)
mail.add_content(SendGrid::Content.new(type: 'text/html', value: "#{msg}"))
sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])
@response = sg.client.mail._('send').post(request_body: mail.to_json)


