class Parent < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :kids
  has_many :payments
  has_one  :prntdetail
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_presence_of :username, :email
  validates :username, uniqueness: true
  validates :email, uniqueness: true
  include HTTParty

end
