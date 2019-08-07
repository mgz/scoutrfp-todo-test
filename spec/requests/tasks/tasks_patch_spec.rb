require 'rails_helper'

RSpec.describe "Tasks API", type: :request do
  describe "PATCH /tasks" do
    let!(:task) {create :task}
    
    context "when new title is present" do
      let(:valid_attrs) {{title: Faker::Superhero.name}}
      before {patch "/api/v1/tasks/#{task.id}", params: {data: {attributes: valid_attrs}}}
      
      it "returns status code 200" do
        expect(response.content_type).to eq("application/json")
        expect(response).to have_http_status(:ok)
      end
      
      it "returns modified Task" do
        expect(json['data']['attributes']['title']).to eql(valid_attrs[:title])
        expect(json['data']['id'].to_i).to eql(task.id)
      end
    end
    
    context "tag management" do
      it "can add tags" do
        new_tags = ["Tag one", "Tag Two"]
        patch "/api/v1/tasks/#{task.id}", params: {data: {attributes: {
          tags: new_tags
        }}}

        json['data']['relationships']['tags']['data'].tap do |data|
          expect(data.map{|tag| tag['title']}).to match_array(new_tags)
        end
      end
      
      it "can remove all tags" do
        task.tag_list = ["Tag one", "Tag Two"]
        task.save!
        task.reload
        expect(task.tag_list.size).to eql(2)
        
        patch "/api/v1/tasks/#{task.id}", params: {data: {attributes: {
          tags: []
        }}}

        task.reload
        expect(task.tag_list.size).to eql(0)
  
        expect(json['data']['relationships']['tags']['data'].length).to eql(0)
      end
    end
    
    context "when data is invalid" do
      it "returns http code 404 when Task is not found" do
        patch "/api/v1/tasks/0", params: {data: {attributes: {}}}
        expect(response).to have_http_status(:not_found)
      end
      
      it "doest't update Task if missing title and tags" do
        expect{patch "/api/v1/tasks/#{task.id}", params: {data: {attributes: {}}}}.to raise_error(ActionController::ParameterMissing)
      end

      it "doest't update Task if blank title" do
        patch "/api/v1/tasks/#{task.id}", params: {data: {attributes: {title: ''}}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors'].first['title']).to eql('"title" can\'t be blank')
      end

      it "doest't update Task with too long title" do
        patch "/api/v1/tasks/#{task.id}", params: {data: {attributes: {title: "X" * 201}}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors'].first['title']).to eql('"title" is too long (maximum is 200 characters)')
      end
    end
    
    context "security" do
      it "doesn't update attributes other than 'title'" do
        task = create(:task)
        old_task_attributes = OpenStruct.new(task.attributes)
        
        patch "/api/v1/tasks/#{task.id}", params: {data: {attributes: {
          title: Faker::Superhero.name,
          id: 0,
          created_at: 0
        }}}
        
        task.reload
        
        expect(task.id).to eql(old_task_attributes.id)
        expect(task.created_at).to eql(old_task_attributes.created_at)

        expect(task.title).not_to eql(old_task_attributes.title)
      end
    end
  end
end