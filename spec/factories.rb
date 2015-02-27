FactoryGirl.define do
  factory :access_grant, class: Cyberbrain::AccessGrant do
    resource_owner_id { SecureRandom.uuid }
    application
    redirect_uri 'https://app.com/callback'
    expires_in 100
    scopes 'public write'
  end

  factory :access_token, class: Cyberbrain::AccessToken do
    resource_owner_id { SecureRandom.uuid }
    application
    expires_in 2.hours

    factory :clientless_access_token do
      application nil
    end
  end

  factory :application, class: Cyberbrain::Application do
    sequence(:name) { |n| "Application #{n}" }
    redirect_uri 'https://app.com/callback'
  end

  factory :account, class: Cyberbrain::Account do
    username { Faker::Name.names }
    password { Faker::Internet.password }
    password_confirmation { password }
  end
end
