class EnrollmentPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def index?
    @user.has_role?(:admin)
  end

  # def show?
  #   @user.has_role?(:admin) || @record.course.user == @user
  # end

  def edit?
    update?
  end

  def update?
    @record.user == @user
  end

  def new?
    # create?
  end

  def create?
    # @record.course.user == @user
  end

  def destroy?
    @user.has_role?(:admin)
  end
end
