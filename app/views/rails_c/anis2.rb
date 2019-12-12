tcan=Tchdetail.where(anis: "true")

a={}
tcan.each do |tc|

if tc.colleges.count > 2
a[tc.id]=tc.colleges.ids
end

tc.tchdetail_colleges.each do |tcl|

if $anis2f.include?(tcl.college_id) || $anis2.include?(tcl.college_id)
tcl.tp = "an2"
else
tcl.tp = "an1"
end

tcl.save

end
end
