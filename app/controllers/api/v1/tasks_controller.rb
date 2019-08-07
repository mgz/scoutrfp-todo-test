class Api::V1::TasksController < ApplicationController
  def index
    tasks = Task.all.includes(:tags)
    render json: tasks
  end
  
  def create
    task = Task.new(task_params)
    if task.save
      render json: task
    else
      render json: {
        errors: task.errors.map do |attr, error|
          {
            status: 422,
            title: "\"#{attr.to_s}\" #{error}"
          }
        end
      }, status: :unprocessable_entity
    end
  end
  
  def update
    if (task = Task.find_by_id(params[:id]))
      if TaskUpdater.call(task, task_params, self)
        render json: task
      else
        render json: {
          errors: task.errors.map do |attr, error|
            {
              status: 422,
              title: "\"#{attr.to_s}\" #{error}"
            }
          end
        }, status: :unprocessable_entity
      end
    else
      render json: {
        errors: [
          {
            status: 404,
            title: "Task not found"
          }
        ]
      }, status: :not_found
    end
  end
  
  private
  def task_params
    params.require(:data).require(:attributes).permit(:title)
  end
end
