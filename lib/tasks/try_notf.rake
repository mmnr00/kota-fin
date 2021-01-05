desc "Try Notf"
task try_notf: :environment do

	url = "https://www.isms.com.my/isms_send.php?"
	usr = "un=kotamy&"
	ps = "pwd=#{ENV['ismsk']}&"
	tp = "type=1&"
	trm = "agreedterm=YES"
	to = "dstno=60174151556&"
	txt = "msg=Payment reminder from PERSATUAN PENDUDUK LEP3 Please click https://www.kota.my/list_bill?cls=pjtjzb to view and make payment.&"
	data_sms = HTTParty.get("#{url}#{usr}#{ps}#{to}#{txt}#{tp}#{trm}", timeout: 120)
	puts "#{url}#{usr}#{ps}#{to}#{txt}#{tp}#{trm}"
end
