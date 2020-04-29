t=Taska.all
#t=Taska.where.not(id: [5, 9, 1, 44, 45, 4, 48])
t.each do |tsk|

if !tsk.fotos.where(foto_name: "COMPANY LOGO").present?
Foto.create(foto_name: "COMPANY LOGO", taska_id: tsk.id)
end

if !tsk.tsklvs.where(name: "UNPAID LEAVE").present?
Tsklv.create(name: "UNPAID LEAVE", desc: "PLEASE EDIT YOUR DESCRIPTION AND NO OF DAYS", day: 15, taska_id: tsk.id)
end

end

t=Taska.all
#t=Taska.where.not(id: [5, 9, 1, 44, 45, 4, 48])
t.each do |tsk|

if !tsk.fotos.where(foto_name: "CENTER HANDBOOK").present?
Foto.create(foto_name: "CENTER HANDBOOK", taska_id: tsk.id)
end

end