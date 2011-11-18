class Role < ActiveRecord::Base
  attr_accessible :name, :level, :read, :commit, :export, :check, :modify, :admin
  belongs_to :user
end
