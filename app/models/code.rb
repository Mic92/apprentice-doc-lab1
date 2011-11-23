class Code < ActiveRecord::Base
  attr_accessible :name, :code
  has_many :templates
  validates :code, :name, :presence => true
end
