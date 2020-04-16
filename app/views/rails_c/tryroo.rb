#require 'roo'
xlsx = Roo::Spreadsheet.open('./Borang_JMB.xlsx')
header = xlsx.row(xlsx.first_row+2)
c=[]
d=[]
((xlsx.first_row+4)..(xlsx.last_row)).each do |n|
xlsx.row(n)
row = Hash[[header, xlsx.row(n)].transpose]

if row["BLOCK/ROAD"].present?

#create Date
own_dtl=row["OWNER DETAILS"].split(";")
dt = own_dtl[1]
c<<Date.new(dt[7..10].to_i,dt[4,5].to_i,dt[1,2].to_i)

#create vehicle
vhcl=row["VEHICLES LIST"].split(";")
d<<vhcl

end

end
