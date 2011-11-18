class Ihk < ActiveRecord::Base
  attr_accessible :name
  has_many :templates
end
