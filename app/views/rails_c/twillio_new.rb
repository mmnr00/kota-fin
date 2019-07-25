@client = Twilio::REST::Client.new("AC20d97b44982215d0d6c1735427ac04d9", "09f7f440e627fb473e479ea9a7cad234")
        @client.messages.create(
          to: "+60174151556",
          from: "+13345186527",
          body: "Test. Mus_Rehan "
        )
        
@client = Twilio::REST::Client.new("AC20d97b44982215d0d6c1735427ac04d9", "09f7f440e627fb473e479ea9a7cad234")
        @client.messages.create(
          to: "whatsapp:+60174151556",
          from: "whatsapp:+14155238886",
          body: "Mus Rehan Try Whatsapp"
        )
        