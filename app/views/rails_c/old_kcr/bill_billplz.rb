Payment.where(mtd: nil).where(paid: true).each do |bill|
bill.mtd = "BILLPLZ"
bill.save
end
