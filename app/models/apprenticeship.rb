class Apprenticeship < ActiveRecord::Base
  belongs_to :instructor, :class_name => "User"
  belongs_to :apprentice, :class_name => "User"
end
