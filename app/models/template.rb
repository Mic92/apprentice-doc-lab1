class Template < ActiveRecord::Base
  attr_accessible :name
  belongs_to :job
  belongs_to :ihk
  belongs_to :code
  validates :name, :presence => true
end
