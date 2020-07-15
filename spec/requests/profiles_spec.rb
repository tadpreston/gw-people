require 'rails_helper'

RSpec.describe "/profiles", type: :request do
  before do
    sign_in FactoryBot.create(:user, password: 'password', password_confirmation: 'password')
  end

  describe "GET /profile" do
    it "render a successful response" do
      get profile_url
      expect(response).to be_successful
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {
          first_name: 'George',
          last_name: 'Jones'
        }
      }

      it "updates the requested profile" do
        patch profile_url, params: { profile: new_attributes }
        expect(response).to redirect_to(profile_url)
      end
    end
  end
end
