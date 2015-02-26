require 'spec_helper'

describe Cyberbrain::User do
  subject { FactoryGirl.build :user }

  it { should have_secure_password }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_length_of(:username).is_at_most(35) }
  it { should allow_value(Faker::Name.first_name).for(:username) }
  it { should_not allow_value('a' * 36, '_', '', '!@#$%^&*()_+``', '中文').for(:username) }
end
