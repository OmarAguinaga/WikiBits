require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create(:user) }
  it { is_expected.to have_many(:wikis) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_length_of(:email).is_at_least(3) }
  it { is_expected.to allow_value('user.wiki@mail.com').for(:email)}

  it { is_expected.to validate_length_of(:password)}
  it { is_expected.to validate_length_of(:password).is_at_least(6)}

  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_uniqueness_of(:username) }

  describe 'atributes' do
    it "Should have username and email attributes" do
      expect(user).to have_attributes(username: user.username, email: user.email)
    end

    it "responds to role" do
      expect(user).to respond_to(:role)
    end
    it "responds to admin?" do
      expect(user).to respond_to(:admin?)
    end
    it "responds to member?" do
      expect(user).to respond_to(:member?)
    end
  end

  describe "Roles" do
    it "is member by default" do
      expect(user.role).to eql("member")
    end

    context "member user" do
      it "returns true for #member?" do
        expect(user.member?).to be_truthy
      end

      it "returns false for #admin?" do
        expect(user.admin?).to be_falsey
      end
    end

    context "admin user" do
      before do
        user.admin!
      end

      it "returns false for #member?" do
        expect(user.member?).to be_falsey
      end

      it "returns true for #admin?" do
        expect(user.admin?).to be_truthy
      end
    end
  end

  describe 'Invalid user' do
    let(:user_with_invalid_mail) {build(:user, email:'')}
    let(:user_with_invalid_name) {build(:user, username:'')}


    it "should be an invalid user due to blank email" do
      expect(user_with_invalid_mail).to_not be_valid
    end

    it "should be an invalid user due to blank email" do
      expect(user_with_invalid_name).to_not be_valid
    end
  end

  describe "After creation" do
    it "Send confirmation emai" do
      new_user = FactoryGirl.build :user
      expect { user.save }.to change(
      Devise.mailer.deliveries, :count
      ).by(1)
    end
  end
end
