require 'rails_helper'

feature "User registers" do
  let(:user){ create :user }

  scenario "with valid details" do
    visit "/"

    click_link "Sign up"
    expect(current_path).to eq(new_user_registration_path)

    fill_in "Username", with: "Test User"
    fill_in "Email", with: "tester@example.tld"
    fill_in "Password", with: "test-password"
    fill_in "Password confirmation", with: "test-password"
    click_button "Sign up"

    expect(current_path).to eq "/"
    expect(page).to have_content(
    "A message with a confirmation link has been sent to your email address.
    Please follow the link to activate your account."
    )

    open_email "tester@example.tld", with_subject: "Confirmation instructions"
    visit_in_email "Confirm my account"

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content "Your email address has been successfully confirmed."

    fill_in "Login", with: "tester@example.tld"
    fill_in "Password", with: "test-password"
    click_button "Log in"

    expect(current_path).to eq "/"
    expect(page).to have_content "Signed in successfully."
    expect(page).to have_content "Hello, Test User"
  end

  context "with invalid details" do
    before do
      visit new_user_registration_path
    end

    scenario "blank fields" do

      expect_fields_to_be_blank

      click_button "Sign up"

      expect(page).to have_content "Email can't be blank",
      "Password can't be blank",
      "Username can't be blank"
    end

    scenario "incorrect password confirmation" do

      fill_in "Username", with: "Test User"
      fill_in "Email", with: "tester@example.tld"
      fill_in "Password", with: "test-password"
      fill_in "Password confirmation", with: "not-test-password"
      click_button "Sign up"

      expect(page).to have_content "Password confirmation doesn't match Password"
    end

    scenario "already registered email" do

      create(:user, email: "same@example.tld")

      fill_in "Email", with: "same@example.tld"
      fill_in "Password", with: "test-password"
      fill_in "Password confirmation", with: "test-password"
      click_button "Sign up"

      expect(page).to have_content "Email has already been taken"
    end

    scenario "invalid email" do

      fill_in "Usernam", with: "Test User"
      fill_in "Email", with: "invalid-mail"
      fill_in "Password", with: "test-password"
      fill_in "Password confirmation", with: "test-password"
      click_button "Sign up"

      expect(page).to have_content "Email is invalid"
    end

  end

  private

  def expect_fields_to_be_blank

    expect(page).to have_field("Email", with: "", type: "email")
    # These password fields don't have value attributes in the generated HTML,
    # so with: syntax doesn't work.
    expect(find_field("Password", type: "password").value).to be_nil
    expect(find_field("Password confirmation", type: "password").value).to be_nil
  end
end
