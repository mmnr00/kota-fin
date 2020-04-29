Expense.all.each do |exp|
exp.dt = exp.created_at
exp.save
end