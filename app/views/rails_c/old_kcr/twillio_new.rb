@client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_KEY"])
        @client.messages.create(
          to: "+60174151556",
          from: ENV["TWILIO_PHONE_NO"],
          body: "Test. Mus_Rehan "
        )
        
@client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_KEY"])
        @client.messages.create(
          to: "whatsapp:+60174151556",
          from: "whatsapp:+14155238886",
          body: "Mus Rehan Try Whatsapp"
        )
        