require 'rails_helper'

RSpec.describe "/tasks", type: :request do
  describe "GET" do
    let!(:tasks) {create_list(:task, 10)}
    before {get '/api/v1/tasks'}
    after {expect_code_200}
    
    it "returns status code 200" do
    end
    
    it "returns all Tasks" do
      expect(response.body).to have_json_size(tasks.size).at_path('data')
      
      expect(first_json_data).to have_type('tasks')
      
      received_titles = json['data'].map{|rec| rec.dig('attributes', 'title')}
      expect(received_titles).to match_array(tasks.map{|t| t.title})
    end
  end
  
  describe "GET (Expect Tags)" do
    it "Tasks have Tags" do
      task = create(:task)
      Tagger.new(task, [Faker::Superhero.unique.name, Faker::Superhero.unique.name]).save_tags
      task.save!
      task.reload
      
      get '/api/v1/tasks'
      expect(first_json_data).to have_type('tasks')
      
      expect(response.body).to have_json_path('data/0/relationships')
      expect(response.body).to have_json_path('data/0/relationships/tags')
      
      response_at('data/0/relationships/tags/data').tap do |data|
        expect(data.size).to eql(2)
        expect(data.map{|tag| tag['title']}).to match_array(task.tags.map(&:title))
      end
    end
  end
end