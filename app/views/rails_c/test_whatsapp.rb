@taska = Taska.find(3)
cls = Classroom.find(115)

url = "https://sms.360.my/gw/bulk360/v1.4?"
usr = "user=admin@kidcare.my&"
ps = "pass=#{ENV['SMS360']}&"
to = "to=whatsapp:60174151556&"
txt = "text=#{@taska.name} : Monthly Fees Notification - Dear Residents, please click https://www.kota.my/list_bill?cls=#{cls.unq} to view and make payment. If you are unable to click the link, please save (add to contact) this number, or reply 'yes' to this message. Thank you for your continuous support - RUSDI B RUSLAN, Pengerusi Persatuan Penduduk Komuniti LEP3"

fixie = URI.parse "http://fixie:2lSaDRfniJz8lOS@velodrome.usefixie.com:80"
data_sms = HTTParty.get(
"#{url}#{usr}#{ps}#{to}#{txt}",
http_proxyaddr: fixie.host,
http_proxyport: fixie.port,
http_proxyuser: fixie.user,
http_proxypass: fixie.password
)
