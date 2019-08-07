class Task < ApplicationRecord
  acts_as_taggable
  
  validates_presence_of :title
  validates :title, length: { maximum: 200 }
  
  MAX_TAGS = 10
end
