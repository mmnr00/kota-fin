Tchdetail.where(anis: "true").each do |tcd|
Foto.create(foto_name: "OPLN",tchdetail_id: tcd.id) unless tcd.fotos.where(foto_name: "OPLN").present?
Foto.create(foto_name: "CRTJ",tchdetail_id: tcd.id) unless tcd.fotos.where(foto_name: "CRTJ").present?
Foto.create(foto_name: "OPLN1",tchdetail_id: tcd.id) unless tcd.fotos.where(foto_name: "OPLN1").present?
Foto.create(foto_name: "SSM1",tchdetail_id: tcd.id) unless tcd.fotos.where(foto_name: "SSM1").present?
end
