tsk=[72,66,61,59,55,56,54,53,52,50,49,47,46]
cltid={72=>"zcwcyfc2",66=>"eaf0w8ws",61=>"rsimya7d",59=>"rmttjlgv",55=>"40bx20ao",56=>"40bx20ao",54=>"kwkamuzp",53=>"h3xuyihc",52=>"1y3glusm",50=>"uekqxp1s",49=>"uekqxp1s",47=>"nseb_5tl",46=>"nseb_5tl"}

Taska.find(tsk).each do |t|
t.collection_id2 = cltid[t.id]
t.save
end



Taska.where(collection_id: "x7w_y71n").each do |tsk|
tsk.collection_id2 = "x7w_y71n"
tsk.save
end

t=Taska.find(76)
t.collection_id="zvfa1md1"
t.collection_id2="orjc1zxi"
t.save