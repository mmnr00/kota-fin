Expense.all.each do |exp|
unq = (('a'..'z').to_a + (0..9).to_a).sample(6).join
while Expense.where(exp_id: unq).present?
unq = (('a'..'z').to_a + (0..9).to_a).sample(6).join
end
exp.exp_id = unq
exp.save
end