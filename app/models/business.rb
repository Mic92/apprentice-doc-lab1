class Business < ActiveRecord::Base
  attr_accessible :name, :zipcode, :street, :city

  has_many :users
end
