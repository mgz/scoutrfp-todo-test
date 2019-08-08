class Api::V1::TasksController < ApplicationController
  before_action :find_task, only: [:update, :destroy]
  
  def index
    tasks = Task.all.includes(:tags)
    render json: tasks
  end
  
  def create
    task = Task.new(task_params)
    if task.save
      render json: task
    else
      render_jsonapi_error_for(task)
    end
  end
  
  def update
    if TaskUpdater.call(@task, task_params, self)
      render json: @task
    else
      render_jsonapi_error_for(@task)
    end
  end
  
  def destroy
    if @task.destroy
      head :ok
    else
      render json: {
        errors: [
          {
            status: 500,
            title: 'Error destroying task'
          }
        ]
      }, status: :internal_server_error
    end
  end
  
  private
  def task_params
    params.require(:data).require(:attributes).permit(:title)
  end

  def find_task
    unless (@task = Task.find_by_id(params[:id]))
      render_resource_not_found(Task)
      return false
    end
  end
end
