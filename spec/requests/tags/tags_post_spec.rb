require 'rails_helper'

RSpec.describe "/tags", type: :request do
  describe "POST" do
    context "when title is present" do
      let(:valid_attrs) {{title: Faker::Superhero.name}}
      before {post '/api/v1/tags', params: {data: {attributes: valid_attrs}}}
      after {expect_code_200}
      
      it "returns status code 201" do

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
        expect(first_jsonapi_error).to eql('"title" can\'t be blank')
      end
      
      it "rejects Tag with too long title" do
        post '/api/v1/tags', params: {data: {attributes: {title: "X" * 201}}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(first_jsonapi_error).to eql('"title" is too long (maximum is 200 characters)')
      end
    end

    it "rejects duplicate Tags" do
      tag = create(:tag)
      post '/api/v1/tags', params: {data: {attributes: {
        title: tag.title
      }}}

      expect(response).to have_http_status(:unprocessable_entity)
      expect(first_jsonapi_error).to eql('Tag is not unique')
      
    end

  end
end