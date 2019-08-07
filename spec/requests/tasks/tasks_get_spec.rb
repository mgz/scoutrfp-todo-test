require 'rails_helper'

RSpec.describe "Tasks API", type: :request do
  describe "GET /tasks" do
    let!(:tasks) {create_list(:task, 10)}
    before {get '/api/v1/tasks'}
    
    it "returns status code 200" do
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end
    
    it "returns all Tasks" do
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
      
      expect(response.body).to have_json_size(tasks.size).at_path('data')
      
      expect(json['data'][0]).to have_type('tasks')
      
      received_titles = json['data'].map{|rec| rec.dig('attributes', 'title')}
      expect(received_titles).to match_array(tasks.map{|t| t.title})
      
      # expect(parsed_json['data'].first).to eql(titles.first)
      # expect(parsed_json['data'].second).to eql(titles.second)
    end
  end
end