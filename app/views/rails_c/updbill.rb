
Payment.where(name: "KID BILL",paid: true,mtd: nil).each do |pb|
url_bill = "#{ENV['BILLPLZ_API']}bills/#{pb.bill_id}"
data_billplz = HTTParty.get(url_bill.to_str,
      :body  => {}.to_json, 
                  #:callback_url=>  "YOUR RETURN URL"}.to_json,
      :basic_auth => { :username => ENV['BILLPLZ_APIKEY'] },
      :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
#render json: data_billplz and return
data = JSON.parse(data_billplz.to_s)
if data["paid"] == true
pb.paid = true
pb.updated_at = data["paid_at"]
pb.save
end
end

Payment.where(name: "KID BILL",paid: true,mtd: nil).each do |pb|
if pb.taska_id == 54
puts pb.taska_id
end
end
