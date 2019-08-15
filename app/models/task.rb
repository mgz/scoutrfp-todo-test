class Task < ApplicationRecord
  has_many :taggings
  has_many :tags, through: :taggings
  
  validates_presence_of :title
  validates :title, length: { maximum: 200 }
  
  MAX_TAGS = 10
end
