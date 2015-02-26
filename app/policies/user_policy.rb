class UserPolicy
  def initialize(user, record)
    @user   = user
    @record = record
  end

  def destroy?
    true
  end
end
