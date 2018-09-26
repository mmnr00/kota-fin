class Teacher < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  	has_many :taska_teachers
	has_many :taskas, through: :taska_teachers
  	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

 	 validates_presence_of :username, :email
end
