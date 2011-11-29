class Code < ActiveRecord::Base
  attr_accessible :name, :code, :codegroup
  has_many :templates
  validates :code, :codegroup, :name, :presence => true
end
