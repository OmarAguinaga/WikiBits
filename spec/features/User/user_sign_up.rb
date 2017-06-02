require 'rails_helper'

describe "the signup process", :type => :feature do

  it "signs me in" do
    visit '/users/sign_up'
    # within("#new-user") do
      fill_in 'Username', with: 'User'
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
    # end
    click_button 'Sign up'
    # expect(page).to have_content 'confirmation'
    expect(page).to have_current_path(root))
  end
end
