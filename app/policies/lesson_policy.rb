class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def show?
    @user.has_role?(:admin) || @record.course.user == @user || @record.course.bought(@user) == false
  end

  def edit?
    update?
  end

  def update?
    @record.course.user == @user
  end

  def new?
    # create?
  end

  def create?
    @record.course.user == @user
  end

  def destroy?
    @record.course.user == @user
  end

end
