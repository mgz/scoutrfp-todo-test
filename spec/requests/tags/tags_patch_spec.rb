require 'rails_helper'

RSpec.describe "/tags", type: :request do
  describe "PATCH" do
    let!(:tag) {create :tag}
    
    context "when new title is present" do
      let(:valid_attrs) {{title: Faker::Superhero.name}}
      before {patch "/api/v1/tags/#{tag.id}", params: {data: {attributes: valid_attrs}}}
      after {expect_code_200}
      
      it "returns status code 200" do

      end
      
      it "returns modified Tag" do
        expect(response_at('data/attributes/title')).to eql(valid_attrs[:title])
        expect(response_at('data/id').to_i).to eql(tag.id)
      end
    end
    
    context "when data is invalid" do
      after do
        expect(Tag.count).to eq 1
      end
      
      it "returns http code 404 when Tag is not found" do
        patch "/api/v1/tags/0", params: {data: {attributes: {}}}
        expect(response).to have_http_status(:not_found)
      end
      
      it "doest't update Tag if missing title" do
        expect{patch "/api/v1/tags/#{tag.id}", params: {data: {attributes: {}}}}.to raise_error(ActionController::ParameterMissing)
      end

      it "doest't update Tag if blank title" do
        patch "/api/v1/tags/#{tag.id}", params: {data: {attributes: {title: ''}}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(first_jsonapi_error).to eql('"title" can\'t be blank')
      end

      it "doest't update Tag with too long title" do
        patch "/api/v1/tags/#{tag.id}", params: {data: {attributes: {title: "X" * 201}}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(first_jsonapi_error).to eql('"title" is too long (maximum is 200 characters)')
      end
    end
  end
end