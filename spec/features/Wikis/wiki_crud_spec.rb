require 'rails_helper.rb'

describe 'Creating Wiki CRUD with logged in user' do
  let(:sentence){ Faker::Lorem.sentence }
  let(:updated_sentence){ Faker::Lorem.sentence }


  let(:topic){ FactoryGirl.create(:topic)}

  before do
    user = FactoryGirl.create(:user)
    user.confirm
    login_as(user, :scope => :user)

    @wiki = FactoryGirl.create(:wiki, title: sentence, topic: topic)
  end

  it "Creates wiki" do
    visit topics_path
    click_link topic.name
    expect(current_path).to eq topic_path(topic.id)
    click_link 'New Wiki'
    expect(current_path).to eq  new_topic_wiki_path(topic)
    fill_in 'Title', with: sentence
    fill_in 'Body', with: Faker::Lorem.paragraph
    click_button 'Save'
    expect(current_path).to eq topic_wiki_path(@wiki.topic, 2)
    expect(page).to have_content sentence
  end

  it "Shows Wikis" do
    visit_wiki
    expect(page).to have_content sentence
  end

  it "Edits Wikis" do
    visit_wiki
    click_link 'Edit'
    expect(current_path).to eq edit_topic_wiki_path(@wiki.topic, @wiki.id)
    fill_in 'Title', with: updated_sentence
    click_button 'Save'
    expect(page).to have_content updated_sentence
    expect(current_path).to eq topic_wiki_path(@wiki.topic, @wiki.id)
  end

  it "Deletes Wiki" do
    visit_wiki
    click_link "Delete Wiki"
    expect(current_path).to eq topic_path(topic.id)
    expect(page).to have_content "\"#{sentence}\"  was deleted successfully."
  end
end



describe "Wiki CRUD with Not Logged in user" do
  let(:sentence){ Faker::Lorem.sentence }
  let(:updated_sentence){ Faker::Lorem.sentence }

  let(:topic){ FactoryGirl.create(:topic)}


  before do
    @wiki = FactoryGirl.create(:wiki, title: sentence, topic: topic)
  end

  it "gets redirected to login page if not logged in" do
    visit root_path
    click_link 'All topics'
    expect(current_path).to eq new_user_session_path
  end

  it "Should be able to Shows Wikis" do
    visit_wiki
    expect(current_path).to eq topic_wiki_path(@wiki.topic, @wiki.id)
  end

  it "Should not show Edits Wikis link" do
    visit_wiki
    page.should have_no_content('Edit')
  end

  it "Should not show Delete Wikis link" do
    visit_wiki
    page.should have_no_content('Delete')
  end
end


private
def visit_wiki
  visit topics_path
  click_link topic.name
  click_link sentence
  expect(current_path).to eq topic_wiki_path(@wiki.topic, @wiki.id)
end
