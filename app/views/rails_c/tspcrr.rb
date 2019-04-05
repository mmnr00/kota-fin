tsk = Taska.find(46)
tsk.payments.where.not(name: "TASKA PLAN").where(paid: true).each do |bl|
dt = Date.new(bl.bill_year, bl.bill_month)
bl.updated_at = dt
bl.save
end