a={}

a[53]=2.4/3
a[54]=2.8/3
a[55]=2.4/3
a[56]=2.4/3
a[61]=2.8/3
a[66]=2.8/3
a[72]=1
a[76]=2.8/3
a[80]=2.4/3
a[81]=2.4/3

a.each do |k,v|
t = Taska.find(k)
t.discount = v.to_f
t.save
end

ts=Admin.first.taskas
ts.each do |t|
t.expire = Date.today + 3.days
t.save
end
