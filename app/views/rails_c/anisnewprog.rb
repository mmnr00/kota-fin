College.find(51).courses.each do |crs|
a = crs.dup
a.college_id = 54
a.save
crs.anisprogs.each do |ap|
b = ap.dup
b.course_id = a.id 
b.save
end
end

 