require 'rails_helper'

RSpec.describe "/tasks", type: :request do
  describe "DELETE" do
    let!(:tasks) {create_list(:task, 10)}

    it "deletes a Task" do
      prev_task_count = Task.count
      task = Task.first
      task.tag_list = ['Some tag']
      task.save!
      
      delete "/api/v1/tasks/#{task.id}"
      expect(response).to have_http_status(:ok)
      expect(Task.count).to eql(prev_task_count - 1)
    end
    
    it "shows error when Task doesn't exist" do
      delete "/api/v1/tasks/0"
      expect(response).to have_http_status(:not_found)
    end
    
  end
end
