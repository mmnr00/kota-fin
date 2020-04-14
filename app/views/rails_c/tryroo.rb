#require 'roo'
xlsx = Roo::Spreadsheet.open('./Borang_JMB.xlsx')
header = xlsx.row(xlsx.first_row+2)
((xlsx.first_row+4)..(xlsx.last_row)).each do |n|
xlsx.row(n)
row = Hash[[header, xlsx.row(n)].transpose]
if row["BLOCK/ROAD"].present?
puts row["OWNER DETAILS"]
end
#Classroom.create(classroom_name: row["NAME"], taska_id: row["TASKA"], base_fee: row["BASE FEE"])
end
