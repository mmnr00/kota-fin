#KidBill.all.each do |kb|
Payment.find(488).kid_bills.each do |kb|

kid = kb.kid

kb.kidname = kid.name
kb.kidic = "#{kid.ic_1}-#{kid.ic_2}-#{kid.ic_3}"
kb.clsname = kb.classroom.classroom_name
kb.clsfee = kb.classroom.base_fee

kb.extra.each do |k|
extra = Extra.find(k)
kb.extradtl[extra.name] = extra.price
kb.save
end

end