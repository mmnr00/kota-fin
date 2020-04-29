

$anissys20.each do |k,v|
t=Taska.new
t.name = v[0]
t.address_1 = v[1]
t.supervisor = v[2]
t.phone_1 = v[3]
t.email = v[4]
t.city = v[5]
t.plan = "ansys19"
t.save
end
