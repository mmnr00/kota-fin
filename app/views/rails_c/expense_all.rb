Expense.all.each do |exp|
unq = (('a'..'z').to_a + (0..9).to_a).sample(6).join
while Expense.where(exp_id: unq).present?
unq = (('a'..'z').to_a + (0..9).to_a).sample(6).join
end
exp.exp_id = unq
exp.save

if exp.kind == "EXPENSE"
	Foto.create(expense_id: exp.id, foto_name: "EXPENSE DOC")
end

end