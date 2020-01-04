class Admin < ApplicationRecord

	has_many :taska_admins
	has_many :taskas, through: :taska_admins
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #attr_accessible :email, :password, :password_confirmation, :remember_me, :username

  validates_presence_of :username, :email
  validates :username, uniqueness: true
  validates :email, uniqueness: true


end
