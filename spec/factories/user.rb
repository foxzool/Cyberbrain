FactoryGirl.define do
  factory :user do
    username { Faker::Name.first_name }
    password { Faker::Internet.password }
    password_confirmation { password }
  end
end
