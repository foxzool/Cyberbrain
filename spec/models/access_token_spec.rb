require 'spec_helper'

describe Cyberbrain::AccessToken do
  subject { Cyberbrain::AccessToken.create(user_id: SecureRandom.uuid) }

  it { should be_valid }

  describe '#verify' do
    it 'return expired when time pass' do
      token = subject
      Timecop.travel(20.minutes)

      expect(token.verify).to eq Cyberbrain::AccessToken::EXPIRED
      Timecop.return
    end

    it 'return revoked when token has been revoke' do
      subject.revoke

      expect(subject.verify).to eq Cyberbrain::AccessToken::REVOKED
    end

    it 'return INSUFFICIENT_SCOPE when scopes not right' do
      expect(subject.verify(['bad'])).to eq Cyberbrain::AccessToken::INSUFFICIENT_SCOPE
    end
  end
end
