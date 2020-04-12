desc "try rake"
task try_sch: :environment do 
	cls = Classroom.all
	cls.each do |cl|
		puts cl.classroom_name
	end
end