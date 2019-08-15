require 'rails_helper'

RSpec.describe "/tags", type: :request do
  describe "GET" do
    let!(:tags) {create_list(:tag, 10)}
    before {get '/api/v1/tags'}
    after {expect_code_200}
    
    it "returns status code 200" do
    end
    
    it "returns all Tags" do
      expect(response.body).to have_json_size(tags.size).at_path('data')
      
      expect(first_json_data).to have_type('tags')
      
      received_titles = json['data'].map{|rec| rec.dig('attributes', 'title')}
      expect(received_titles).to match_array(tags.map{|t| t.title})
    end
  end
end