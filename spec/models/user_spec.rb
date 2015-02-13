require 'spec_helper'

describe User do
  it 'create with right params' do
    user = create(:user)
    expect(user).to be_valid
  end
end
