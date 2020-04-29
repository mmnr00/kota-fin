cls_id = 1
t=Taska.find(cls_id)

t.classrooms.each do |cls|
Foto.create(foto_name:"Owner Pic",classroom_id: cls.id)
Foto.create(foto_name:"Tenant Pic",classroom_id: cls.id)

end
