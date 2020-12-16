require 'test_helper'

class DeleteTest < ActionDispatch::IntegrationTest

  def create_admin_user
    user = User.new(email:"admin@test.com",name:'maikeAdmin',password:'123456',password_confirmation:'123456',admin:true)
    user.save
    get"/sign_in"
    post"/sign_in_post",params:{email: 'admin@test.com', password: '123456'}
  end

  def create_user
    create_admin_user
    get "/admin_dash/create/user"
    post "/admin_dash/create/user_post", params:{user: {email:"user@test.com",name:'maikeUser',password:'123456'}}
  end

  def create_account
    create_user
    user = User.find_by_email("user@test.com")
    get "/admin_dash/create/account/#{user.id}"
    post "/admin_dash/create/account_post/#{user.id}", params:{account:{name: 'testAccount', currency: '$'}}
  end

  def create_transaction
    create_account
    account=Account.find_by_name('testAccount')
    get "/admin_dash/create/transaction/#{account.id}"
    post "/admin_dash/create/transaction_post/#{account.id}", params:{transaction:{amount: -10, description: 'tesco', completed_on: '2020-10-15'}}
  end

  test "delete user" do
    create_user
    user = User.find_by_email('user@test.com')
    assert_difference 'User.count', -1 do
      delete "/admin_dash/delete/user/#{user.id}"
    end
  end

  test "delete account" do
    create_account
    account = Account.find_by_name('testAccount')
    assert_difference 'Account.count', -1 do
      delete "/admin_dash/delete/account/#{account.id}"
    end
  end

  test "delete transaction" do
    create_transaction
    transaction = Transaction.find_by_amount(-10)
    assert_difference 'Transaction.count', -1 do
      delete "/admin_dash/delete/transaction/#{transaction.id}"
    end
  end

end
