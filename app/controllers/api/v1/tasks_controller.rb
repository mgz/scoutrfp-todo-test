class Api::V1::TasksController < ApplicationController
  def index
    tasks = Task.all
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
  
  private
  def task_params
    params.require(:data).require(:attributes).permit(:title)
  end
end
