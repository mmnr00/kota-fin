tsk=[52,50,49,47,46]
cltid={52=>"1y3glusm",50=>"uekqxp1s",49=>"uekqxp1s",47=>"nseb_5tl",46=>"nseb_5tl"}

Taska.find(tsk).each do |t|
t.collection_id2 = cltid[t.id]
t.save
end



Taska.where(collection_id: "x7w_y71n").each do |tsk|
tsk.collection_id = "x7w_y71n"
tsk.save
end

t=Taska.find()
t.collection_id=""
t.save