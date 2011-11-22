class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :forename, :zipcode, :street, :city, :email, :password, :salt
  belongs_to :role
  belongs_to :business
  belongs_to :instructor, :class_name => "User", :foreign_key => "instructor_id"
  has_many :reports
  has_many :apprentices, :class_name => "User", :foreign_key => "instructor_id"
  
end
