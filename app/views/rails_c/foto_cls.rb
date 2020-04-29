# cls_id = 1
# t=Taska.find(cls_id)

Taska.all.each do |t|

t.classrooms.each do |cls|
Foto.create(foto_name:"Owner Pic",classroom_id: cls.id)
Foto.create(foto_name:"Tenant Pic",classroom_id: cls.id)

# if Foto.where(foto_name:"Owner Pic",classroom_id: cls.id).count > 1
# 	Foto.where(foto_name:"Owner Pic",classroom_id: cls.id).last.destroy
# end
# if Foto.where(foto_name:"Tenant Pic",classroom_id: cls.id).count > 1
# 	Foto.where(foto_name:"Tenant Pic",classroom_id: cls.id).last.destroy
# end

end
end
