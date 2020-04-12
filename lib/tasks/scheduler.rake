desc "try rake"
task try_sch: :environment do 
	cls = Classroom.all
	cls.each do |cl|
		puts cls.classroom_name
	end
end