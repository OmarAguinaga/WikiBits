require 'rails_helper.rb'

describe 'Creating Wiki CRUD with logged in user' do
  let(:sentence){ Faker::Lorem.sentence }
  let(:updated_sentence){ Faker::Lorem.sentence }

  let(:topic){ FactoryGirl.create(:topic)}


  before :each do
    @user=FactoryGirl.create(:user)
    @user.confirm
    @other_user = FactoryGirl.create(:user)
    @other_user.confirm

    @wiki =FactoryGirl.create(:wiki, title: sentence, topic: topic, user: @user)
  end

  context "Any logged in user" do
    before do
      login_as(@user, :scope => :user)
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
  end

  #**************
  #*STANDAR USER*
  #**************
  context "Standar user" do
    before do
      login_as(@user, :scope => :user)
    end

    it "#Edit" do
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

  context "Standar user doing CRUD on wiki the DO NOT own" do
    before do
      login_as(@other_user, :scope => :user)
    end

    it "Does not Show Edit or Delete button on Wikis" do
      visit_wiki
      expect(page).to have_no_content "Edit Wiki"
      expect(page).to have_no_content "Delete Wiki"
      expect(current_path).to eq topic_wiki_path(@wiki.topic, @wiki.id)
    end

    it "Does not Edits Wikis with direct path" do
      visit edit_topic_wiki_path(@wiki.topic, @wiki.id)
      expect(current_path).to eq topic_wiki_path(@wiki.topic, @wiki.id)
      expect(page).to have_content "You must be an admin to do that."
    end
  end

  #**************
  #*PREMIUM USER*
  #**************

  context "Premium user doing CRUD on own wiki" do
    before do
      @user.premium!
      login_as(@user, :scope => :user)
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

  context "premium user doing CRUD on wiki the DO NOT own" do
    before do
      @other_user.premium!
      login_as(@other_user, :scope => :user)
    end

    it "Does not Show Edit or Delete button on Wikis" do
      visit_wiki
      expect(page).to have_no_content "Edit Wiki"
      expect(page).to have_no_content "Delete Wiki"
      expect(current_path).to eq topic_wiki_path(@wiki.topic, @wiki.id)
    end

    it "Does not Edits Wikis with direct path" do
      visit edit_topic_wiki_path(@wiki.topic, @wiki.id)
      expect(current_path).to eq topic_wiki_path(@wiki.topic, @wiki.id)
      expect(page).to have_content "You must be an admin to do that."
    end
  end

  #************
  #*ADMIN USER*
  #************

  context "Admin user doing CRUD on wiki the DO NOT own" do
    before do
      @other_user.admin!
      login_as(@other_user, :scope => :user)
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
end

#************
#*GUEST USER*
#************

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
    expect(current_path).to eq topics_path
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
