Owner.find(8).colleges.each do |clg|
clg.tchdetails.each do |tchd|
if !tchd.fotos.where(foto_name: "DEPOSIT PAYMENT RECEIPT").present?
f=Foto.new(foto_name: "DEPOSIT PAYMENT RECEIPT", tchdetail_id: tchd.id)
f.save
end
end
end
