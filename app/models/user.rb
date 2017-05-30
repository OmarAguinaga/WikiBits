class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates :username,
  length: { minimum: 1, maximum: 100 },
  presence: true,
  uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }

  validates :email,
  presence:  true,
  uniqueness: { case_sensitive: false },
  length: { minimum: 3, maximum: 254 }




  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login



  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

end
