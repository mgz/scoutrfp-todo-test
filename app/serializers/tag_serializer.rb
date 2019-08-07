class TagSerializer < ActiveModel::Serializer
  attributes :id, :title
  
  def title
    object.name
  end
end
