clg = College.find(54)
tchds = clg.tchdetails

clg.courses.each do |crs|
crs.anisprogs.where.not(name: "BREAK").each do |an|
tchds.each do |tch|
Anisatt.create(course_id: crs.id, tchdetail_id: tch.id, anisprog_id: an.id, att: true)
end
end
end

clg = College.find(51)
tchds = clg.tchdetails
tchds.each do |tch|
if !tch.post.present?
tch.post = "CHILDCARE PROVIDER"
tch.save
end
end
