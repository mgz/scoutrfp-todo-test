require 'rails_helper'

RSpec.describe "/tasks", type: :request do
  describe "POST" do
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

      it "rejects Task with too long title" do
        post '/api/v1/tasks', params: {data: {attributes: {title: "X" * 201}}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors'].first['title']).to eql('"title" is too long (maximum is 200 characters)')
      end
    end
  end
end