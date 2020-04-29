#KidBill.all.each do |kb|
#Payment.find(1157).kid_bills.each do |kb|
Payment.where(name: "KID BILL").each do |ppt|
ppt.kid_bills.each do |kb|

kid = kb.kid

kb.kidname = kid.name
kb.kidic = "#{kid.ic_1}-#{kid.ic_2}-#{kid.ic_3}"
if kb.classroom.present?
kb.clsname = kb.classroom.classroom_name
kb.clsfee = kb.classroom.base_fee
end

kb.extra.each do |k|
extra = Extra.find(k)
kb.extradtl[extra.name] = extra.price
end

kb.save
end

end

Payment.where(name: "KID BILL", paid: true).where(mtd: nil).each do |ppm|
ppm.mtd = "BILLPLZ"
ppm.save
end

