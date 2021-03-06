class Wiki < ApplicationRecord
  default_scope { order('private DESC') }

  belongs_to :user

  has_many :collaborators
  has_many :collaborator_users, through: :collaborators, :source => :user
  

  belongs_to :topic
  validates :title, length: {minimum: 5}, presence: true
  validates :body, length: {minimum: 20}, presence: true
  validates :user, presence: true
end
