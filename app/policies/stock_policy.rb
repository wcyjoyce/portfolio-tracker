class StockPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    return true
  end

  def update?
    # record.user == user
    return true
  end

  def destroy?
    # record.user == user
    return true
  end
end
