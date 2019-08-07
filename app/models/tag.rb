class Tag < ApplicationRecord
  alias_attribute :title, :name

  validates_presence_of :title
  validates_uniqueness_of :title
  validates :title, length: { maximum: 200 }
end