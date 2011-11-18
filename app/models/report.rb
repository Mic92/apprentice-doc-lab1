class Report < ActiveRecord::Base
  attr_accessible :period_start, :period_end
  belongs_to :user
  has_many :report_entries, :dependent => :destroy
  has_many :statuses
end
