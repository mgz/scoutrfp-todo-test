FactoryBot.define do
  factory :task do
    title {Faker::Superhero.unique.name}
  end
end