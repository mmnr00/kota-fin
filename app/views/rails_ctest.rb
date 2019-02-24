t=Taska.find(1)
tchdid = Array.new
t.classrooms.each do |cls|
cls.teachers.each do |tch|
tchdid << tch.tchdetail.id
end
end
a=Tchdetail.where(id: tchdid)
