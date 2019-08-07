require 'rails_helper'

RSpec.describe "Tags API", type: :request do
  describe "POST /tags" do
    context "when title is present" do
      let(:valid_attrs) {{title: Faker::Superhero.name}}
      before {post '/api/v1/tags', params: {data: {attributes: valid_attrs}}}
      
      it "returns status code 201" do
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
      end
      
      it "returns created Tag" do
        json['data'].tap do |data|
          expect(data['id'].to_i).to be > 0
          expect(data['type']).to eql('tags')
          expect(data['attributes']['title']).to eql(Tag.first.title)
        end
      end
    end
    
    context "when data is invalid" do
      after do
        expect(Tag.count).to eq 0
      end
      
      it "rejects Tag with missing title" do
        expect{post '/api/v1/tags', params: {data: {attributes: {}}}}.to raise_error(ActionController::ParameterMissing)
      end
      
      it "rejects Tag with blank title" do
        post '/api/v1/tags', params: {data: {attributes: {title: ''}}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors'].first['title']).to eql('"title" can\'t be blank')
      end
      
      it "rejects Tag with too long title" do
        post '/api/v1/tags', params: {data: {attributes: {title: "X" * 201}}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors'].first['title']).to eql('"title" is too long (maximum is 200 characters)')
      end
    end

    it "rejects duplicate Tags" do
      tag = create(:tag)
      post '/api/v1/tags', params: {data: {attributes: {
        title: tag.title
      }}}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors'][0]['title']).to eql('"title" has already been taken')
      
    end

  end
end