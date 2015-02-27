class AccountPolicy
  def initialize(account, record)
    @account = account
    @record = record
  end

  def destroy?
    true
  end
end
