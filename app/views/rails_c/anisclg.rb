c=College.find(43)
c.tchdetails.each do |tch|
tch_clg = tch.tchdetail_colleges.first
tch_clg.college_id = 45
tch_clg.save
end