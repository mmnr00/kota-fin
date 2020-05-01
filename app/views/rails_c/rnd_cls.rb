
#arr=[]
Classroom.all.each do |cls|
	unq = (0...6).map { ('a'..'z').to_a[rand(26)] }.join
	while Classroom.where(unq: unq).present? #arr.include? unq 
		unq = (0...6).map { ('a'..'z').to_a[rand(26)] }.join
	end
	cls.unq = unq
	cls.save
	#arr << unq
end

arr = []
Classroom.all.each do |cls|
	arr<<cls.unq
end
#check duplicate
fin=arr.select{|v| arr.count(v) > 1}.uniq

