require 'rails_helper'

RSpec.describe "Task model", type: :model do
  describe "is taggable" do
    let!(:tasks) {create_list(:task, 10)}
    let!(:tag) {Faker::Superhero.unique.name}
    it "can add Tags" do
      task = Task.first
  
      Tagger.new(task, [tag]).save_tags
      task.save!
      task.reload
      
      expect(Tagging.last.task.id).to eql(task.id)
      expect(Tagging.last.tag.title).to eql(tag)
    end

    it "can change Tags" do
      task = Task.first

      Tagger.new(task, [tag]).save_tags
      task.save!
      task.reload
  
      expect(task.tags.count).to eql(1)

      Tagger.new(task, [Faker::Superhero.unique.name, Faker::Superhero.unique.name]).save_tags
      task.save!
      task.reload

      expect(task.tags.count).to eql(2)
    end
    
    it "can delete tags" do
      task = Task.first
      Tagger.new(task, [tag]).save_tags
      task.save!
      task.reload

      expect(Tagging.count).to eql(1)

      Tagger.new(task, []).save_tags
      task.save!
      task.reload

      expect(task.tags.count).to eql(0)
    end
    
    it "can have comma in Tag title" do
      task = Task.first
  
      tag_with_comma = 'Some, Tag'
      Tagger.new(task, [tag_with_comma]).save_tags
      task.save!
      task.reload
      
      expect(task.tags.count).to eql(1)
      expect(task.tags.map(&:title)).to match_array([tag_with_comma])
    end
  end
end
