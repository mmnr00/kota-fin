Tchdetail.where(anis: "true", dun: "  Sungai Air Tawar  ").each do |t|
t.dun = " Sungai Air Tawar  "
t.save
end


c=1
$sel_dun.each do |k|
if c<10
puts "N0#{c}#{k.upcase}"
else
puts "N#{c}#{k.upcase}"
end
c=c+1
end


