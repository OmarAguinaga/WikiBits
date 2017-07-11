require 'rails_helper.rb'

describe 'Creating Wiki CRUD with logged in user' do
  let(:sentence){ Faker::Lorem.sentence }
  let(:private_sentence){ Faker::Lorem.sentence }
  let(:updated_sentence){ Faker::Lorem.sentence }
  let(:private_updated_sentence){ Faker::Lorem.sentence }
  let(:topic){ FactoryGirl.create(:topic)}
  let(:private_topic){ FactoryGirl.create(:topic, name: Faker::Lorem.sentence )}
  
  let(:private_tag){'PRIVATE'}


  before :each do
    @user=FactoryGirl.create(:user)
    @user.confirm
    @other_user = FactoryGirl.create(:user)
    @other_user.confirm

    @wiki =FactoryGirl.create(:wiki, title: sentence, topic: topic, user: @user)
    @private_wiki =FactoryGirl.create(:wiki, title: private_sentence, topic: private_topic, user: @user, private: true)
  end

  context "Any logged in user" do
    before do
      login_as(@user, :scope => :user)
    end

    it "Creates wiki" do
      visit topics_path
      click_link topic.name
      expect(page).to have_current_path(topic_path(topic.id))
      click_link 'New Wiki'
      expect(page).to have_current_path(new_topic_wiki_path(topic))
      fill_in 'Title', with: sentence
      fill_in 'Body', with: Faker::Lorem.paragraph
      click_button 'Save'
      expect(page).to have_current_path(topic_wiki_path(@wiki.topic, 3))
      expect(page).to have_content sentence
    end

    it "Shows Wikis" do
      visit_wiki
      expect(page).to have_content sentence
    end
    
    it "Shows makdown as HTML" do
      visit_wiki
      expect(page).to have_css('pre')
    end
    
    it 'is not able to create provate wikis' do
      visit_wiki
      expect(page).to have_no_css('.checkbox')
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
      expect(page).to have_current_path(edit_topic_wiki_path(@wiki.topic, @wiki.id))
      fill_in 'Title', with: updated_sentence
      click_button 'Save'
      expect(page).to have_content updated_sentence
      expect(page).to have_current_path(topic_wiki_path(@wiki.topic, @wiki.id))
    end

    it "Deletes Wiki" do
      visit_wiki
      click_link "Delete Wiki"
      expect(page).to have_current_path(topic_path(topic.id))
      expect(page).to have_content "\"#{sentence}\"  was deleted successfully."
    end
    
    it 'is not able to create private wikis' do
      visit_wiki
      expect(page).to have_no_css('.checkbox')
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
      expect(page).to have_current_path(topic_wiki_path(@wiki.topic, @wiki.id))
    end

    it "Does not Edits Wikis with direct path" do
      visit edit_topic_wiki_path(@wiki.topic, @wiki.id)
      expect(page).to have_current_path(topic_wiki_path(@wiki.topic, @wiki.id))
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
      expect(page).to have_current_path(edit_topic_wiki_path(@wiki.topic, @wiki.id))
      fill_in 'Title', with: updated_sentence
      click_button 'Save'
      expect(page).to have_content updated_sentence
      expect(page).to have_current_path(topic_wiki_path(@wiki.topic, @wiki.id))
    end

    it "Deletes Wiki" do
      visit_wiki
      click_link "Delete Wiki"
      expect(page).to have_current_path(topic_path(topic.id))
      expect(page).to have_content "\"#{sentence}\"  was deleted successfully."
    end
    
    it 'is able to create private wikis' do
      new_wiki
      click_link 'New Wiki'
      expect(page).to have_current_path(new_topic_wiki_path(topic))
      fill_in 'Title', with: sentence
      fill_in 'Body', with: Faker::Lorem.paragraph
      expect(page).to have_css('.checkbox')
      check 'Private wiki'
      click_button 'Save'
      expect(page).to have_current_path(topic_wiki_path(@wiki.topic, 3))
      expect(page).to have_content sentence
      expect(page).to have_content private_tag
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
      expect(page).to have_current_path(topic_wiki_path(@wiki.topic, @wiki.id))
    end

    it "Does not Edits Wikis with direct path" do
      visit edit_topic_wiki_path(@wiki.topic, @wiki.id)
      expect(page).to have_current_path(topic_wiki_path(@wiki.topic, @wiki.id))
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
      expect(page).to have_current_path(edit_topic_wiki_path(@wiki.topic, @wiki.id))
      fill_in 'Title', with: updated_sentence
      click_button 'Save'
      expect(page).to have_content updated_sentence
      expect(page).to have_current_path(topic_wiki_path(@wiki.topic, @wiki.id))
    end

    it "Deletes Wiki" do
      visit_wiki
      click_link "Delete Wiki"
      expect(page).to have_current_path(topic_path(topic.id))
      expect(page).to have_content "\"#{sentence}\"  was deleted successfully."
    end
    
    
    #PRIVATE WIKIS
    
    it 'is able to create private wikis' do
      new_wiki
      click_link 'New Wiki'
      expect(page).to have_current_path(new_topic_wiki_path(topic))
      fill_in 'Title', with: sentence
      fill_in 'Body', with: Faker::Lorem.paragraph
      expect(page).to have_css('.checkbox')
      check 'Private wiki'
      click_button 'Save'
      expect(page).to have_current_path(topic_wiki_path(@wiki.topic, 3))
      expect(page).to have_content sentence
      expect(page).to have_content private_tag
    end
    
    it "Edits Private Wikis" do
      visit_private_wiki
      expect(page).to have_content private_tag
      click_link 'Edit'
      expect(page).to have_current_path(edit_topic_wiki_path(@private_wiki.topic, @private_wiki.id))
      fill_in 'Title', with: private_updated_sentence
      click_button 'Save'
      expect(page).to have_content private_updated_sentence
      expect(page).to have_current_path(topic_wiki_path(@private_wiki.topic, @private_wiki.id))
    end

    it "Deletes Private Wiki" do
      visit_private_wiki
      expect(page).to have_content private_tag
      click_link "Delete Wiki"
      expect(page).to have_current_path(topic_path(private_topic.id))
      expect(page).to have_content "\"#{private_sentence}\"  was deleted successfully."
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
    expect(page).to have_current_path(topics_path)
  end

  it "Should be able to view Wikis" do
    visit_wiki
    expect(page).to have_current_path(topic_wiki_path(@wiki.topic, @wiki.id))
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
    expect(page).to have_current_path(topic_wiki_path(@wiki.topic, @wiki.id))
  end
  
  def visit_private_wiki
    visit topics_path
    click_link private_topic.name
    click_link private_sentence
    expect(page).to have_current_path(topic_wiki_path(@private_wiki.topic, @private_wiki.id))
  end
  
  def new_wiki
    visit topics_path
    click_link topic.name
    expect(page).to have_current_path(topic_path(topic.id))
  end
