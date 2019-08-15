require 'rails_helper'

RSpec.describe Tagging, type: :model do
  let!(:task) {create :task}
  it "is threadsafe" do
    threads = []
    20.times do
      threads << Thread.new{
        Tagger.new(task, ['aa', 'bb']).save_tags
      }
    end
    threads.each{|t| t.join}
  end
end
