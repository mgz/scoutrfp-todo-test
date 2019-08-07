require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "Tags" do
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
  end
end
