require 'spec_helper'

describe AccountPolicy do
  let(:account) { FactoryGirl.create :account }

  subject { AccountPolicy }

  permissions :destroy? do
    it 'grant access' do
      expect(subject).to permit(account, account)
    end
  end
end
