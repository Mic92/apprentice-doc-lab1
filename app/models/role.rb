class Role < ActiveRecord::Base
  attr_accessible :name, :read, :commit, :export, :check, :modify, :admin
  has_many :users
  
  # validations
  
  validates :name, :uniqueness => true, :presence => true
  validates :read, :commit, :export, :check, :modify, :admin, :inclusion => { :in => [true, false] }
  
  
  
end
