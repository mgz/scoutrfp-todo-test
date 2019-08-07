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
  
  describe "POST /tasks" do
    context "when title is present" do
      let(:valid_attrs) {{title: Faker::Superhero.name}}
      before {post '/api/v1/tasks', params: {data: {attributes: valid_attrs}}}
      
      it "returns status code 201" do
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
      end
      
      it "returns created Task" do
        json['data'].tap do |data|
          expect(data['id'].to_i).to be > 0
          expect(data['type']).to eql('tasks')
          expect(data['attributes']['title']).to eql(Task.first.title)
        end
      end
    end
    
    context "when data is invalid" do
      after do
        expect(Task.count).to eq 0
      end
      
      it "rejects Task with missing title" do
        expect{post '/api/v1/tasks', params: {data: {attributes: {}}}}.to raise_error(ActionController::ParameterMissing)
      end
  
      it "rejects Task with blank title" do
        post '/api/v1/tasks', params: {data: {attributes: {title: ''}}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors'].first['title']).to eql('"title" can\'t be blank')
      end
    end
  end
end
