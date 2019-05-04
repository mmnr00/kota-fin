c=College.find(43)
c.tchdetails.each do |tch|
tch_clg = tch.tchdetail_colleges.first
tch_clg.college_id = 45
tch_clg.save
end

  
tc = Tchdetail.where(ic_1: "680302", ic_2: "10", ic_3: "6532").first
tc.anis = "true"
tc.save
tcl=TchdetailCollege.new
tcl.tchdetail_id= tc.id 
tcl.college_id = 46
tcl.save
