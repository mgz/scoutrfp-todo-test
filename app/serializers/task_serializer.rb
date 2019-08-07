class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title
  has_many :tags
  
  def tags
    object.tags.map do |tag|
      {
        id: tag.id.to_s,
        title: tag.name
      }
    end
  end
end
