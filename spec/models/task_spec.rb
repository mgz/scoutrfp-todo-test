require 'rails_helper'

RSpec.describe "Task model", type: :model do
  describe "is taggable" do
    let!(:tasks) {create_list(:task, 10)}
    let!(:tag) {Faker::Superhero.unique.name}
    it "can add Tags" do
      task = Task.first
  
      task.tag_list.add(tag)
      task.save!
      task.reload
      
      expect(Task.tagged_with(tag).size).to eql(1)
    end

    it "can change Tags" do
      task = Task.first

      task.tag_list.add(tag)
      task.save!
      task.reload
  
      expect(Task.tagged_with(tag).size).to eql(1)

      task.tag_list = [Faker::Superhero.unique.name, Faker::Superhero.unique.name]
      task.save!
      task.reload

      expect(Task.tagged_with(tag).size).to eql(0)
      expect(task.tags.count).to eql(2)
    end
    
    it "can have comma in Tag title" do
      task = Task.first
  
      tag_with_comma = 'Some, Tag'
      task.tag_list = tag_with_comma
      task.save!
      task.reload
      
      expect(task.tag_list.size).to eql(1)
      expect(task.tag_list).to match_array([tag_with_comma])
    end
  end
end
