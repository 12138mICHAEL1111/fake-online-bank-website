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

  test 'account with name contains number is not valid ' do
    user=users(:testUser)
    account = Account.new(balance:0, currency:'$', user_id:user.id, name:'123z')
    assert_not account.save
  end

  test 'account with name which are all number is not valid ' do
    user=users(:testUser)
    account = Account.new(balance:0, currency:'$', user_id:user.id, name:'123')
    assert_not account.save
  end
end
