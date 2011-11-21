class Business < ActiveRecord::Base
  attr_accessible :name, :zipcode, :street, :city

  has_many :users

  validates :name, :zipcode, :street, :city, :presence => true
end
