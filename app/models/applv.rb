class Applv < ApplicationRecord
	belongs_to	:teacher
	belongs_to	:taska
	has_many :fotos, :dependent => :delete_all
	accepts_nested_attributes_for :fotos

end
