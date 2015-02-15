require 'spec_helper'

describe UserPolicy do
  let(:user) { FactoryGirl.create :user }

  subject { UserPolicy }

  permissions :destroy? do
    it 'grant access' do
      expect(subject).to permit(user, user)
    end
  end
end
