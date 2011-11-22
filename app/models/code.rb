class Code < ActiveRecord::Base
  has_many :templates
  validates :code, :presence => true
end
