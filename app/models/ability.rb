class Ability
  include Hydra::Ability

  include Hyrax::Ability

  self.ability_logic += [:everyone_can_create_curation_concerns]

  def can_create_any_work?
    Hyrax.config.curation_concerns.any? do |curation_concern_type|
      can?(:create, curation_concern_type)
    end
  end

  def editor_abilities
    super
    if current_user.admin?
      # can :create, TinymceAsset
      can [:create, :update], ContentBlock
    end
  end

  # Define any customized permissions here.
  def custom_permissions
    if current_user.admin?
      can [:read, :create, :update, :destroy], Role
      can :manage, :all
    end

    # Limits deleting objects to a the admin user
    #
    # if current_user.admin?
    #   can [:destroy], ActiveFedora::Base
    # end

    # Limits creating new objects to a specific group
    #
    # if user_groups.include? 'special_group'
    #   can [:create], ActiveFedora::Base
    # end
  end
end
