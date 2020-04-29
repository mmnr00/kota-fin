require 'sendgrid-ruby'
include SendGrid

#NEW TRY
mail = SendGrid::Mail.new
mail.from = Email.new(email: 'do-not-reply@kidcare.my', name: 'KidCare.my')
mail.subject = 'Hello World from the SendGrid Ruby Library'
#Personalisation, add cc
personalization = SendGrid::Personalization.new
personalization.add_to(SendGrid::Email.new(email: 'mmnr00@gmail.com', name: 'MUS'))
personalization.add_cc(SendGrid::Email.new(email: 'test3@example.com', name: 'Example User'))
mail.add_personalization(personalization)
#add content
mail.add_content(Content.new(type: 'text/html', value: '<html><body><strong>MUS</strong></body></html>'))
sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])
response = sg.client.mail._('send').post(request_body: mail.to_json)


# OLD TRY
from = SendGrid::Email.new(email: 'do-not-reply@kidcare.my', name: 'KidCare.my')
to = SendGrid::Email.new(email: 'mmnr00@gmail.com')
subject = '[CC] New Leave Application'
#Personalisation, add cc
personalization = SendGrid::Personalization.new
personalization.add_to(SendGrid::Email.new(email: 'test2@example.com', name: 'Example User'))
personalization.add_cc(SendGrid::Email.new(email: 'test3@example.com', name: 'Example User'))
#Start content
content = SendGrid::Content.new(type: 'text/plain', value: 'From Ariff To Pizul')
mail = SendGrid::Mail.new(from, subject, to, content)
mail.add_personalization(personalization)

sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])
response = sg.client.mail._('send').post(request_body: mail.to_json)


