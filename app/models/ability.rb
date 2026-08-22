# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
     # Define abilities for the user here. For example:
     #
     return unless user.present?
    can :manage, ApiCredential, user_id: user.id
    can :read, CashSnapshot, user_id: user.id
    can :manage, User, id: user.id

    #   return unless user.admin?
    #   can :manage, :all
  end
end
