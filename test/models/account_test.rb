require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "account with all parameters filled with correct validation is valid" do
    user=users(:testUser)
    account = Account.new(balance:0, currency:'$', user_id:user.id, name:'maike')
    assert account.save
  end

  test "account with no name is not valid" do
    user=users(:testUser)
    account = Account.new(balance:0, currency:'$', user_id:user.id)
    assert_not account.save
  end


end
