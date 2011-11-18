class Status < ActiveRecord::Base
  attr_accessible :date, :comment
  belongs_to :report
end
