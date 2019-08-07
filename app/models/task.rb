class Task < ApplicationRecord
  validates_presence_of :title
  validates :title, length: { maximum: 200 }
end
