Payment.where(name: "TASKA PLAN").each do |p|
p.cltid = "fabqzqb0"
p.save
end

Payment.where.not(name: "TASKA PLAN").where.not(taska_id: nil).where(cltid: nil).each do |p|
p.cltid = p.taska.collection_id
p.save
end

Taska.where(collection_id: nil).each do |t|

t.collection_id = $clt
t.save
end

#default cltid where taska do not have bank account = "andkymil"