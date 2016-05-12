class User < ActiveRecord::Base
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Role-management behaviors.
  include Hydra::RoleManagement::UserRoles


  # Connects this user object to Curation Concerns behaviors.
  include CurationConcerns::User
  # Connects this user object to Sufia behaviors.
  include Sufia::User
  include Sufia::UserUsageStats




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
      self.department = extract_department(attrs[:nuPosition1].first)
    end
  end

  # Extracts the department name from the nuPosition1 NU LDAP field
  # nuPosition1 is formmatted: title$$department$$address$$$mailcode
  def extract_department(ldapposition)
    positionarr = Array.new
    deptname = String.new

    positionarr = ldapposition.split('$$');
    if (positionarr[1]) 
      deptname = positionarr[1]
    else 
      deptname = nil
    end 
    
    return deptname
  end
end
