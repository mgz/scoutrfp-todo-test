class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title
  has_many :tags
  
  def tags
    object.tags.map do |tag|
      {
        id: tag.id,
        name: tag.name
      }
    end
  end
end
