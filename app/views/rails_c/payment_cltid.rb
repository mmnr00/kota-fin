Payment.where(name: "TASKA PLAN").each do |p|
p.cltid = "fabqzqb0"
p.save
end

Payment.where.not(name: "TASKA PLAN").where(cltid: nil).each do |p|
p.cltid = "olga_843"
p.save
end

Taska.where(cltid: nil).each do |t|
if Rails.env.development?
t.cltid = "andkymil"
elsif Rails.env.production?
t.cltid = "x7w_y71n"
end
t.save
end

#default cltid where taska do not have bank account = "andkymil"