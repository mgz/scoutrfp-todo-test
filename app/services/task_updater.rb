class TaskUpdater
  def self.call(task, task_params, context)
    if (tag_list = context.params.dig(:data, :attributes, :tags)).present?
      if tag_list.length > Task::MAX_TAGS
        task.errors.add(:base, "Too many tags (max #{Task::MAX_TAGS} allowed)")
        return false
      end
      task.tag_list = tag_list
    end
    task.update(task_params)
  end
end