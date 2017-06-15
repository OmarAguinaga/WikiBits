class Topic < ApplicationRecord
  has_many :wikis, dependent: :destroy
end
