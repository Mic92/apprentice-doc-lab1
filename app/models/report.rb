class Report < ActiveRecord::Base
  attr_accessible :name
  belongs_to :user
  has_many :report_entries, :dependent => :destroy
  has_many :statuses
end
