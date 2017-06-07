require 'rails_helper'

feature "User logs in and logs out" do
  let(:confirmed_user){ create :confirmed_user}
  let(:unconfirmed_user){ create :unconfirmed_user}

  scenario "with correct details" do
    visit "/"

    click_link "Log in"
    expect(page).to have_css("h2", text: "Log in")
    expect(current_path).to eq(new_user_session_path)

    login confirmed_user.email, confirmed_user.password

    #expect(page).to have_css("h1", text: "Welcome to RSpec Rails Examples")
    expect(current_path).to eq "/"
    expect(page).to have_content "Signed in successfully"
    expect(page).to have_content "Hello, #{confirmed_user.username}"

    click_link "Logout"

    expect(current_path).to eq "/"
    expect(page).to have_content "Signed out successfully"
    expect(page).not_to have_content "#{confirmed_user.username}"

  end

  scenario "unconfirmed user cannot login" do

    visit new_user_session_path

    login unconfirmed_user.email, unconfirmed_user.password

    expect(current_path).to eq(new_user_session_path)
    expect(page).not_to have_content "Signed in successfully"
    expect(page).to have_content "You have to confirm your email address before continuing"
  end

  private

  def login(email, password)
    fill_in "Login", with: email
    fill_in "Password", with: password
    click_button "Log in"
  end
end
