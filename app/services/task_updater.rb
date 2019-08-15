class TaskUpdater
  def self.call(task, params)
    tags = params[:tags]
    set_task_tags(task, tags)
    set_task_params(task, params)
  end
  
  private
  def self.set_task_tags(task, tags)
    raise_if_too_many_tags(task, tags)
    task.tag_list = tags
  end

  def self.raise_if_too_many_tags(task, tags)
    if tags && tags.length > Task::MAX_TAGS
      task.errors.add(:base, "Too many tags (max #{Task::MAX_TAGS} allowed)")
      raise ActiveRecord::RecordInvalid.new(task)
    end
  end
  
  def self.set_task_params(task, params)
    params.delete(:tags)
    task.update!(params)
  end
end