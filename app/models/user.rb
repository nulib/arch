class User < ApplicationRecord
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Role-management behaviors.
  include Hydra::RoleManagement::UserRoles
  # Connects this user object to Hyrax behaviors.
  include Hyrax::User
  include Hyrax::UserUsageStats

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :username, :email, :password, :password_confirmation
  end

  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  class << self
    def find_or_create_system_user(user_key)
      find_or_create_by(email: user_key)
    end

    def from_omniauth(auth)
      username = auth.uid
      email = auth.info.email
      display_name = auth.info.name

      (User.find_by(username: username) ||
        User.find_by(email: email) ||
        User.create(username: username, email: email, display_name: display_name)).tap do |user|
          if user.username.nil? || user.email.nil? || user.display_name.nil?
            user.username = username
            user.email = email
            user.display_name = display_name
            user.save
          end
        end
    end

    def whois(str)
      return nil if str.nil?
      find_by('email = :str OR username = :str', str: str)&.user_key
    end
  end
end
