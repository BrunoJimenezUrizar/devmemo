class Ability
  include CanCan::Ability

  def initialize(user)
    #user ||= User.new # guest user (not logged in)
    if user
    
        if user.has_role? :super_admin
            can :manage, :all
        else

            # Todos los usuarios registrados pueden ver el index de universidades
            can :index, University

            # Permisos para el rol de Administrador de universidades

            if University.with_role(:university_admin, user).count > 0

                # Se obtienen las universidades y campuses en que el usuario es administrador de universidades

                universities_ids = University.with_role(:university_admin, user).map(&:id)
                campus_ids = Campus.where(:university_id => universities_ids).map(&:id)

                # Se asignan permisos

                can :read, MobileUser
                can :manage, University, :id => universities_ids
                can :manage, Campus, :university_id => universities_ids
                can :manage, Category, :university_id => universities_ids
                can :manage, Type, :university_id => universities_ids
                can :manage, ComplaintType, :university_id => universities_ids
                can :manage, Complaint, :campus_id => campus_ids
                can :manage, Poi, :campus_id => campus_ids
                can :manage, Por, :campus_id => campus_ids
                can :manage, Event, :campus_id => campus_ids
                can :manage, Building, :campus_id => campus_ids            
                can :manage, Dump, :por_id => Por.where(:campus_id => campus_ids).map(&:id)
                can :manage, Floor, :building_id => Building.where(:campus_id => campus_ids).map(&:id)
                can :manage, Report, :id => Campusreporting.where(:campus_id => campus_ids).map(&:report_id)
            end

            # Permisos para el rol de Administrador de campus

            if Campus.with_role(:campus_admin, user).count > 0

                # Se obtienen las universidades y campuses en que el usuario es administrador de campus

                campuses = Campus.with_role(:campus_admin, user)
                universities_ids = campuses.map(&:university_id)
                campus_ids = campuses.map(&:id)
                can :read, MobileUser
                can :read, University, :id => universities_ids
                can :manage, Campus, :id => campus_ids
                can :manage, Category, :university_id => universities_ids
                can :manage, Type, :university_id => universities_ids
                can :manage, ComplaintType, :university_id => universities_ids
                can :manage, Complaint, :campus_id => campus_ids
                can :manage, Poi, :campus_id => campus_ids
                can :manage, Por, :campus_id => campus_ids
                can :manage, Event, :campus_id => campus_ids
                can :manage, Building, :campus_id => campus_ids            
                can :manage, Dump, :por_id => Por.where(:campus_id => campus_ids).map(&:id)
                can :manage, Floor, :building_id => Building.where(:campus_id => campus_ids).map(&:id)
                can :manage, Report, :id => Campusreporting.where(:campus_id => campus_ids).map(&:report_id)
            end

            # Permisos para el rol de Administrador

            if Campus.with_role(:admin, user).count > 0
                campuses = Campus.with_role(:admin, user)
                universities_ids = campuses.map(&:university_id)
                campus_ids = campuses.map(&:id)
                can :read, University, :id => universities_ids
                can :read, Campus, :id => campus_ids
                can :read, MobileUser
                can :manage, Category, :university_id => universities_ids
                can :manage, Type, :university_id => universities_ids
                can :manage, ComplaintType, :university_id => universities_ids
                can :manage, Complaint, :campus_id => campus_ids
                can :manage, Poi, :campus_id => campus_ids
                can :manage, Por, :campus_id => campus_ids
                can :manage, Event, :campus_id => campus_ids
                can :manage, Building, :campus_id => campus_ids            
                can :manage, Dump, :por_id => Por.where(:campus_id => campus_ids).map(&:id)
                can :manage, Floor, :building_id => Building.where(:campus_id => campus_ids).map(&:id)
                can :manage, Report, :id => Campusreporting.where(:campus_id => campus_ids).map(&:report_id)
            end
        end
    else
        cannot :manage, :all
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
