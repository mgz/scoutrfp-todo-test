FactoryBot.define do
  factory :tag do
    title {Faker::Superhero.unique.name}
  end
end