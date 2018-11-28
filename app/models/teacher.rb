class Teacher < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :taska_teachers
	has_many :taskas, through: :taska_teachers
	has_many :teachers_classrooms
	has_many :classrooms, through: :teachers_classrooms
	has_many :payments
	has_many :teacher_courses
	has_many :courses, through: :teacher_courses
	has_many :teacher_colleges
	has_many :colleges, through: :teacher_colleges
	has_one	 :tchdetail
  	devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

 	 validates_presence_of :username, :email
 	 #attr_accessor :password, :password_confirmation
 	 


 	 def already_has_taska?(teacher_id)
 	 	TaskaTeacher.where(teacher_id: teacher_id).exists?
 	 end

 	 def has_same_taska?(teacher_id, taska_id)
 	 	TaskaTeacher.where(teacher_id: teacher_id, taska_id: taska_id).exists?
 	 end

 	 def self.search(param_1, param_2)
		to_send_back = teachers_matches(param_1, param_2)
		return nil unless to_send_back
		to_send_back
	end

	def self.teachers_matches(param_1, param_2)
		matches('email', param_1, 'username', param_2)
	end

	

	def self.matches(field_name1, param_1, field_name2, param_2)
    	where("#{field_name1}='#{param_1}' OR #{field_name2}='#{param_2}'")

  	end
end
