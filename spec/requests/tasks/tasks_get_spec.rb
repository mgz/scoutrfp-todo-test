require 'rails_helper'

RSpec.describe "/tasks", type: :request do
  describe "GET" do
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
    end
  end
  
  describe "GET (Expect Tags)" do
    it "Tasks have Tags" do
      task = create(:task)
      task.tag_list = [Faker::Superhero.unique.name, Faker::Superhero.unique.name]
      task.save!
      task.reload
      
      get '/api/v1/tasks'
      expect(json['data'][0]).to have_type('tasks')
      
      expect(json['data'][0]['relationships']).to be_present
      expect(json['data'][0]['relationships']['tags']).to be_present

      json['data'][0]['relationships']['tags']['data'].tap do |data|
        expect(data.size).to eql(2)
        expect(data.map{|tag| tag['title']}).to match_array(task.tag_list)
      end
    end
  end
end