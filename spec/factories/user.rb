FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    password { Faker::Internet.password }
    password_confirmation { password }
  end
end
