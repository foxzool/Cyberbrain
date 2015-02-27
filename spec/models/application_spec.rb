require 'spec_helper'

module Cyberbrain
  describe Application do
    let(:new_application) { FactoryGirl.build(:application) }

    let(:uid) { SecureRandom.hex(8) }
    let(:secret) { SecureRandom.hex(8) }

    it 'is invalid without a name' do
      new_application.name = nil
      expect(new_application).not_to be_valid
    end

    it 'generates uid on create' do
      expect(new_application.uid).to be_nil
      new_application.save
      expect(new_application.uid).not_to be_nil
    end

    it 'generates uid on create unless one is set' do
      new_application.uid = uid
      new_application.save
      expect(new_application.uid).to eq(uid)
    end

    it 'is invalid without uid' do
      new_application.save
      new_application.uid = nil
      expect(new_application).not_to be_valid
    end

    it 'is invalid without redirect_uri' do
      new_application.save
      new_application.redirect_uri = nil
      expect(new_application).not_to be_valid
    end

    it 'checks uniqueness of uid' do
      app1     = FactoryGirl.create(:application)
      app2     = FactoryGirl.create(:application)
      app2.uid = app1.uid
      expect(app2).not_to be_valid
    end

    it 'expects database to throw an error when uids are the same' do
      app1     = FactoryGirl.create(:application)
      app2     = FactoryGirl.create(:application)
      app2.uid = app1.uid
      expect { app2.save!(validate: false) }.to raise_error
    end

    it 'generate secret on create' do
      expect(new_application.secret).to be_nil
      new_application.save
      expect(new_application.secret).not_to be_nil
    end

    it 'generate secret on create unless one is set' do
      new_application.secret = secret
      new_application.save
      expect(new_application.secret).to eq(secret)
    end

    it 'is invalid without secret' do
      new_application.save
      new_application.secret = nil
      expect(new_application).not_to be_valid
    end

    describe 'destroy related models on cascade' do
      before(:each) do
        new_application.save
      end

      it 'should destroy its access grants' do
        FactoryGirl.create(:access_grant, application: new_application)
        expect { new_application.destroy }.to change { Cyberbrain::AccessGrant.count }.by(-1)
      end

      it 'should destroy its access tokens' do
        FactoryGirl.create(:access_token, application: new_application)
        FactoryGirl.create(:access_token, application: new_application, revoked_at: Time.now)
        expect do
          new_application.destroy
        end.to change { Cyberbrain::AccessToken.count }.by(-2)
      end
    end

    describe :authorized_for do
      let(:resource_owner) { double(:resource_owner, id: SecureRandom.uuid) }

      it 'is empty if the application is not authorized for anyone' do
        expect(Application.authorized_for(resource_owner)).to be_empty
      end

      it 'returns only application for a specific resource owner' do
        FactoryGirl.create(:access_token)
        token = FactoryGirl.create(:access_token, resource_owner_id: resource_owner.id)
        expect(Application.authorized_for(resource_owner)).to eq([token.application])
      end

      it 'excludes revoked tokens' do
        FactoryGirl.create(:access_token, resource_owner_id: resource_owner.id, revoked_at: 2.days.ago)
        expect(Application.authorized_for(resource_owner)).to be_empty
      end

      it 'returns all applications that have been authorized' do
        token1 = FactoryGirl.create(:access_token, resource_owner_id: resource_owner.id)
        token2 = FactoryGirl.create(:access_token, resource_owner_id: resource_owner.id)
        expect(Application.authorized_for(resource_owner)).to eq([token1.application, token2.application])
      end

      it 'returns only one application even if it has been authorized twice' do
        application = FactoryGirl.create(:application)
        FactoryGirl.create(:access_token, resource_owner_id: resource_owner.id, application: application)
        FactoryGirl.create(:access_token, resource_owner_id: resource_owner.id, application: application)
        expect(Application.authorized_for(resource_owner)).to eq([application])
      end

      it 'should fail to mass assign a new application', if: ::Rails::VERSION::MAJOR < 4 do
        mass_assign = { name:         'Something',
                        redirect_uri: 'http://somewhere.com/something',
                        uid:          123,
                        secret:       'something' }
        expect(Application.create(mass_assign).uid).not_to eq(123)
      end
    end

    describe :authenticate do
      it 'finds the application via uid/secret' do
        app           = FactoryGirl.create :application
        authenticated = Application.by_uid_and_secret(app.uid, app.secret)
        expect(authenticated).to eq(app)
      end
    end
  end
end
