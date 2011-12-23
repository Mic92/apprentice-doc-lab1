class Code < ActiveRecord::Base
  attr_accessible :name, :code, :codegroup
  has_many :templates
  validates :code, :codegroup, :name, :presence => true
  validates :name, :length => { :in => 1..200}
end
