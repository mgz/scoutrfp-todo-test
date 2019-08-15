class TaskUpdater
  def self.call(task, params)
    tags = params[:tags]
    task.transaction do
      set_task_tags(task, tags)
      set_task_params(task, params)
    end
  end
  
  private
  def self.set_task_tags(task, tags)
    fail_if_too_many_tags(task, tags)
    Tagger.new(task, tags).save_tags
  end

  def self.fail_if_too_many_tags(task, tags)
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