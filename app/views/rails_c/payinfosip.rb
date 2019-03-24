Payinfo.all.each do |pf|
	pf.sip = 0
	pf.sipa = 0
	pf.save
end

Payslip.all.each do |psl|
	psl.sip = 0
	psl.sipa = 0
	psl.save
end



