require 'rails_helper'

RSpec.describe "Tags API", type: :request do
  describe "GET /tags" do
    let!(:tags) {create_list(:tag, 10)}
    before {get '/api/v1/tags'}
    
    it "returns status code 200" do
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end
    
    it "returns all Tags" do
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
      
      expect(response.body).to have_json_size(tags.size).at_path('data')
      
      expect(json['data'][0]).to have_type('tags')
      
      received_titles = json['data'].map{|rec| rec.dig('attributes', 'title')}
      expect(received_titles).to match_array(tags.map{|t| t.title})
    end
  end
end