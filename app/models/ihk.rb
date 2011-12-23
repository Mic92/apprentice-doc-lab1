class Ihk < ActiveRecord::Base
  attr_accessible :name
  has_many :templates
  validates :name, :presence => true
  validates :name, :length => { :in => 1..200}
end
