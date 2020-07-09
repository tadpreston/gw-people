require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.new(email: "test@test.com") }
  describe ".hello" do
    it "says hello with the email" do
      expect(subject.hello).to eq("Hello test@test.com")
    end
  end
end
