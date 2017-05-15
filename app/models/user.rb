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
  devise :ldap_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    username
  end

  before_validation do
    attrs = self.ldap_entry
    unless attrs.nil?
      self.email = attrs[:mail].first
      self.display_name = attrs[:displayname].first
      if Rails.env.development?
        self.display_name = attrs[:displayName].first
        self.department = attrs[:department].first
      else
        self.display_name = attrs[:displayname].first
        # nuPosition1 is formmatted: title$$department$$address$$$mailcode
        self.department = attrs[:nuPosition1].first.split("$$").second
      end
    end
  end
end
