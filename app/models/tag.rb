class Tag < ApplicationRecord
  has_many :taggings
  has_many :tasks, through: :taggings
  
  validates_presence_of :title
  validates_uniqueness_of :title
  validates :title, length: { maximum: 200 }
end