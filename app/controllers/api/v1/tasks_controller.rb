class Api::V1::TasksController < ApplicationController
  def index
    tasks = Task.all.includes(:tags)
    render json: tasks
  end
  
  def create
    task = Task.new(task_params)
    task.save!
    render json: task
  end
  
  def update
    TaskUpdater.call(task, task_params)
    render json: task
  end
  
  def destroy
    task.destroy
    head :ok
  end
  
  private
  def task_params
    params.require(:data).require(:attributes).permit(:title)
  end

  def task
    @task ||= Task.find(params[:id])
  end
end
