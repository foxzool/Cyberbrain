require 'spec_helper'

describe Cyberbrain::Account do
  subject { FactoryGirl.build :account }

  it { should have_secure_password }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_length_of(:username).is_at_most(35) }
  it { should allow_value(Faker::Name.first_name).for(:username) }
  it { should_not allow_value('a' * 36, '_', '', '!@#$%^&*()_+``', '中文').for(:username) }
end
