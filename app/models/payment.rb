class Payment < ApplicationRecord
	include HTTParty

	url_collection = 'https://billplz-staging.herokuapp.com/api/v3/collections'
    url_bill = 'https://billplz-staging.herokuapp.com/api/v3/bills'
    url_bill_get = 'https://billplz-staging.herokuapp.com/api/v3/bills/c7w8c7a3'
    api_key = 'c2b30f37-f5af-407f-9780-4d341ba4f427' #You can get in your billplz setting account
  
    title = "Anything to explainn about your bill"  

    def self.get_collection
    	begin
    		HTTParty.get(url_collection.to_str,
                  :body  => { :title => title }.to_json,
                  :basic_auth => { :username => api_key },
                  :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
    		new(name: find_collection.title)
    	rescue Exception => e
    		return nil
    	end
    end


end
