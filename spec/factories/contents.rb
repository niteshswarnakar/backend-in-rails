FactoryBot.define do
  factory :content do
    title { "My Title" }
    body  { "My Body" }
    association :user
  end
end
