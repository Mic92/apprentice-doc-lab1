class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :forname, :zipcode, :street, :city, :email, :password
  has_one :role
  has_many :reports
  has_many :apprenticeships, :foreign_key => "instructor_id"
  has_many :apprentices, :through => :apprenticeships
  has_one :inverse_apprenticeship, :class_name => "Apprenticeship", :foreign_key => "apprentice_id"
  has_one :instructor, :through => :inverse_apprenticeship
end
