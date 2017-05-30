require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_length_of(:email).is_at_least(3) }
  it { is_expected.to allow_value('user.wiki@mail.com').for(:email)}

  it { is_expected.to validate_length_of(:password)}
  #it { is_expected.to have_secure_password }
  it { is_expected.to validate_length_of(:password).is_at_least(6)}

  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_uniqueness_of(:username) }

  describe 'atributes' do
    it "Should have username and email attributes" do
      expect(user).to have_attributes(username: user.username, email: user.email)
    end
  end

  describe 'Invalid user' do
    let(:user_with_invalid_mail) {build(:user, email:'')}

    it "should be an invalid user due to blank email" do
      expect(user_with_invalid_mail).to_not be_valid
    end
  end
end
