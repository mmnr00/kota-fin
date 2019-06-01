require 'roo'
xlsx = Roo::Spreadsheet.open('./tryroo.xlsx')
header = xlsx.row(xlsx.first_row)
((xlsx.first_row+1)..(xlsx.last_row)).each do |n|
xlsx.row(n)
row = Hash[[header, xlsx.row(n)].transpose]
Classroom.create(classroom_name: row["NAME"], taska_id: row["TASKA"], base_fee: row["BASE FEE"])
end
