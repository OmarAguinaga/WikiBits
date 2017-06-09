require 'rails_helper.rb'

feature 'Creating a wiki' do
  let(:sentence){ Faker::Lorem.sentence }
  let(:updated_sentence){ Faker::Lorem.sentence }
  let(:confirmed_user){ create :confirmed_user}

  scenario 'can create a wiki after loggin' do
    login confirmed_user.email, confirmed_user.password

    expect(current_path).to eq "/"
    expect(page).to have_content "Signed in successfully"
    expect(page).to have_content "Hello, #{confirmed_user.username}"

    visit '/'
    click_link 'Write a wiki'
    expect(current_path).to eq new_wiki_path
    fill_in 'Title', with: sentence
    fill_in 'Body', with: Faker::Lorem.paragraph
    click_button 'Save'
    expect(current_path).to eq "/wikis/1"
    expect(page).to have_content sentence


    #Show wiki
    visit '/wikis'
    click_link sentence
    expect(current_path).to eq "/wikis/1"


    #Edit Wiki
    click_link 'Edit'
    expect(current_path).to eq "/wikis/1/edit"
    fill_in 'Title', with: updated_sentence
    click_button 'Save'
    expect(page).to have_content updated_sentence

    #Delete Wiki
    click_link "Delete Wiki"

  end

  scenario "gets redirected to login page in not logged in" do
    visit '/'
    click_link 'Write a wiki'
    expect(current_path).to eq new_user_session_path
  end




  private

  def login(email, password)
    visit "/"
    click_link "Log in"
    expect(page).to have_css("h2", text: "Log in")
    expect(current_path).to eq(new_user_session_path)
    fill_in "Login", with: email
    fill_in "Password", with: password
    click_button "Log in"
  end
end
