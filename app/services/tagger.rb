class Tagger
  def initialize(task, tags)
    @task = task
    @tags = tags
  end
  
  def save_tags
    return if @tags == nil
    filter_empty_tags
    delete_missing_tags
    save_new_tags
  end
  
  private
  def filter_empty_tags
    @tags.delete_if{|tag| tag.empty?}
  end
  
  def delete_missing_tags
    tag_titles_to_delete = @task.tags.map{|tag| tag.title} - @tags.uniq
    tags_to_delete = Tag.where(title: tag_titles_to_delete)
    Tagging.where(tag_id: tags_to_delete).delete_all
  end
  
  def save_new_tags
    @tags.uniq.each do |tag_title|
      tag = Tag.find_or_create_by_threadsafe!(title: tag_title)
      Tagging.find_or_create_by_threadsafe!(task_id: @task.id, tag_id: tag.id)
    end
  end
  
  
end