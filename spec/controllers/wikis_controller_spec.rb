require 'rails_helper'


RSpec.describe WikisController, type: :controller do

  let(:my_user) {create :user }
  let(:my_wiki) { create :wiki, user: my_user }
  let(:new_wiki_attributes) do
    {
      title: "WikiBits Creative Title",
      body: "The body of this Wiki is longh enough. I like WikiBits",
      user: my_user
    }
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns [my_wiki] to @wikis" do
      get :index
      expect(assigns(:wiki)).to eq([my_wiki])
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "renders the new view" do
      get :new
      expect(response).to render_template :new
    end

    it "instanciates wiki" do
      get :new
      expect(assigns(:wiki)).not_to be_nil
    end
  end

  describe "POST create" do
    it "increases the number of Wikis by 1" do
      expect{post :create, wiki: new_wiki_attributes}.to change(Wiki,:count).by(1)
    end

  end
  # describe "GET #show" do
  #   it "returns http success" do
  #     get :show
  #     expect(response).to have_http_status(:success)
  #   end
  # end
  #

  # describe "GET #edit" do
  #   it "returns http success" do
  #     get :edit
  #     expect(response).to have_http_status(:success)
  #   end
  # end

end
