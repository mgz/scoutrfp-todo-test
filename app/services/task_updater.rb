class TaskUpdater
  def self.call(task, task_params, context)
    if (tag_list = context.params.dig(:data, :attributes, :tags)).present?
      task.tag_list = tag_list
    end
    task.update(task_params)
  end
end