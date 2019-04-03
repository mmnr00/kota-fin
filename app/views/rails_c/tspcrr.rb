tsk = Taska.find(47)
tsk.payments.where.not(name: "TASKA PLAN").each do |bl|
dt = Date.new(bl.bill_year, bl.bill_month)
bl.updated_at = dt
bl.save
end