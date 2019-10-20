old = 60
nw = 62

clg=College.find(old)
clgn = College.find(nw)

clg.courses.each do |crs|
a = crs.dup
a.college_id = nw

if a.name == "DAY 1"
a.start = clgn.start
elsif a.name == "DAY 2"
a.start = clgn.start + 1.days
elsif a.name == "DAY 3"
a.start = clgn.end
end

a.save

crs.anisprogs.each do |ap|
b = ap.dup
b.course_id = a.id 
b.save
end

end

 