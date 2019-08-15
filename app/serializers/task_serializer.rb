class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title
  has_many :tags
  
  def tags
    object.tags.sort_by(&:id).map do |tag|
      {
        id: tag.id.to_s,
        title: tag.title
      }
    end
  end
end
