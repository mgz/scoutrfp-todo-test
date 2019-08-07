class Tag < ApplicationRecord
  alias_attribute :title, :name
end