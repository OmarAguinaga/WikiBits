
require 'rails_helper.rb'

describe 'Creating Topic CRUD with logged in user' do
  let(:name){ Faker::Lorem.sentence }
  let(:updated_name){ Faker::Lorem.sentence }
  let(:description){ Faker::Lorem.paragraph }


  context "Guest" do
    before do
      @topic = FactoryGirl.create(:topic, name: name, description: description)
    end

    it "Displays all the topics on the root path" do
      visit '/topics'
      expect(page).to have_content name
      expect(page).to have_content description
    end

    it "Shows the topics on click" do
      visit '/topics'
      expect(page).to have_no_content "+"
      click_link name
      expect(current_path).to eq "/topics/1"
      expect(page).to have_content name
      expect(page).to have_content description
      expect(page).to have_no_content "Edit Topic"
      expect(page).to have_no_content "Delete Topic"
      expect(page).to have_content "New Wiki"
    end

    it "is not able to create new topics" do
      visit new_topic_path
      expect(page).to have_content "You must be logged in to do that"
      expect(current_path).to eq new_user_session_path
    end

    it "is not able to edit topics" do
      visit edit_topic_path(@topic.id)
      expect(page).to have_content "You must be logged in to do that"
      expect(current_path).to eq new_user_session_path
    end

    it "is not able to delete topics" do
      visit edit_topic_path(@topic.id)
      expect(page).to have_content "You must be logged in to do that"
      expect(current_path).to eq new_user_session_path
    end
  end

  context "standar" do
    before do
      user = FactoryGirl.create(:user, role: :standar)
      user.confirm
      login_as(user, :scope => :user)

      @topic = FactoryGirl.create(:topic, name: name, description: description)
    end

    it "Displays all the topics on the root path" do
      visit '/topics'
      expect(page).to have_content name
      expect(page).to have_content description
    end

    it "Shows the topics on click" do
      visit '/topics'
      expect(page).to have_no_content "+"
      click_link name
      expect(current_path).to eq "/topics/1"
      expect(page).to have_content name
      expect(page).to have_content description
      expect(page).to have_no_content "Edit Topic"
      expect(page).to have_no_content "Delete Topic"
      expect(page).to have_content "New Wiki"
    end

    it "is not able to create new topics" do
      visit new_topic_path
      expect(page).to have_content "You must be an admin to do that."
      expect(current_path).to eq topics_path
    end

    it "is not able to edit topics" do
      visit edit_topic_path(@topic.id)
      expect(page).to have_content "You must be an admin to do that."
      expect(current_path).to eq topics_path
    end

    it "is not able to delete topics" do
      visit edit_topic_path(@topic.id)
      expect(page).to have_content "You must be an admin to do that."
      expect(current_path).to eq topics_path
    end

  end

  context "premium" do
    before do
      user = FactoryGirl.create(:user, role: :premium)
      user.confirm
      login_as(user, :scope => :user)

      @topic = FactoryGirl.create(:topic, name: name, description: description)
    end

    it "Displays all the topics on the root path" do
      visit '/topics'
      expect(page).to have_content name
      expect(page).to have_content description
    end

    it "Shows the topics on click" do
      visit '/topics'
      expect(page).to have_no_content "+"
      click_link name
      expect(current_path).to eq "/topics/1"
      expect(page).to have_content name
      expect(page).to have_content description
      expect(page).to have_no_content "Edit Topic"
      expect(page).to have_no_content "Delete Topic"
      expect(page).to have_content "New Wiki"
    end

    it "is not able to create new topics" do
      visit new_topic_path
      expect(page).to have_content "You must be an admin to do that."
      expect(current_path).to eq topics_path
    end

    it "is not able to edit topics" do
      visit edit_topic_path(@topic.id)
      expect(page).to have_content "You must be an admin to do that."
      expect(current_path).to eq topics_path
    end

    it "is not able to delete topics" do
      visit edit_topic_path(@topic.id)
      expect(page).to have_content "You must be an admin to do that."
      expect(current_path).to eq topics_path
    end

  end

  context "Admin" do
    before do
      user = FactoryGirl.create(:user, role: :admin)
      user.confirm
      login_as(user, :scope => :user)

      @topic = FactoryGirl.create(:topic, name: name, description: description)
    end

    it "Displays all the topics on the root path" do
      visit '/topics'
      expect(page).to have_content name
      expect(page).to have_content description
    end

    it "Shows the topics on click" do
      visit '/topics'
      click_link name
      expect(current_path).to eq "/topics/1"
      expect(page).to have_content name
      expect(page).to have_content description
      expect(page).to have_content "Edit Topic"
      expect(page).to have_content "New Wiki"
    end

    it "Can create new topics" do
      visit '/topics'
      click_link '+'
      expect(current_path).to eq new_topic_path
      fill_in 'Name', with: name
      fill_in 'Description', with: description
      click_button 'Save'
      expect(current_path).to eq "/topics/2"
      expect(page).to have_content name
    end

    it "Can edit a topic" do
      visit '/topics'
      click_link name
      expect(current_path).to eq topic_path(@topic)
      click_link 'Edit'
      expect(current_path).to eq edit_topic_path(@topic.id)
      fill_in 'Name', with: updated_name
      fill_in 'Description', with: Faker::Lorem.paragraph
      click_button 'Save'
      expect(current_path).to eq topic_path(@topic.id)
      expect(page).to have_content updated_name
    end

    it "Can delete a topic" do
      visit '/topics'
      click_link name
      expect(current_path).to eq topic_path(@topic)
      click_link 'Delete'
      expect(page).to have_content "\"#{name}\"  was deleted successfully."
    end
  end
end
