require "rails_helper"

RSpec.describe Devise::Mailer do
  it "Sends confirmation mail to the correct email and text" do
    user = FactoryGirl.create(:user)

    confirmation_email = Devise.mailer.deliveries.last
    
    expect(user.email).to eq confirmation_email.to[0]
    expect(confirmation_email.body.to_s).to have_content "You can confirm your account email through the link below"
  end
end
