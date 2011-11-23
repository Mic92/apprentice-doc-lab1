class Template < ActiveRecord::Base
  attr_accessible :name, :code_id, :job_id, :ihk_id
  belongs_to :job
  belongs_to :ihk
  belongs_to :code
  validates :name, :code_id, :job_id, :ihk_id, :presence => true
end
