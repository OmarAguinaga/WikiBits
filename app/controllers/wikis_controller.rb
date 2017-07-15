class WikisController < ApplicationController

  #FIXME    the is a problem with authorization and authentication
  before_action :require_sign_in, except: [:index, :show]

  before_action :authorize_user, except: [:show, :new, :create]

  def index
    @wikis = Wiki.all
  end

  def show
    @wiki = Wiki.find(params[:id])
    authorize @wiki
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @wiki = Wiki.new
  end

  def create

    @topic = Topic.find(params[:topic_id])
    @wiki = @topic.wikis.build(wiki_params)
    @wiki.user = current_user


    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to [@topic, @wiki]
    else
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      render :new
    end
  end


  def edit
    @wiki = Wiki.find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)


    if @wiki.save
      flash[:notice] = "Wiki was updated."
      redirect_to [@wiki.topic, @wiki]
    else
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to @wiki.topic
    else
      flash.now[:alert] = "There was an error deleting the wiki."
      render :show
    end
  end

  private
  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

  def authorize_user
    wiki = Wiki.find(params[:id])
    unless current_user == wiki.user || current_user.admin?
      flash[:alert] = "You must be an admin to do that."
      redirect_to [wiki.topic, wiki]
    end
  end
end
