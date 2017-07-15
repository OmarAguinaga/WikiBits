class WikiPolicy < ApplicationPolicy
  attr_reader :user, :wiki

  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end

  def show?
    if user
      user.admin? || !wiki.private || wiki.private && wiki.user == user
    end
  end
end
