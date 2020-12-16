require 'test_helper'

class EditTest < ActionDispatch::IntegrationTest

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

  test "edit email and name for user with all parameters validated is valid" do
    create_user
    user = User.find_by_email("user@test.com")
    get "/admin_dash/edit/user/#{user.id}"
    assert_select 'h2', "Edit User"

    post "/admin_dash/edit/user_post/#{user.id}", params:{user:{email:"maike.zhang@gmail.com", name:"maikeEdit"}}
    user.update(email:"maike.zhang@gmail.com", name:"maikeEdit")
    assert user.save, 'cannot save the user'
    assert_redirected_to "/admin_dash"
  end

  test "edit user with incorrect email format validated is not valid" do
    create_user
    user = User.find_by_email("user@test.com")

    get "/admin_dash/edit/user/#{user.id}"
    assert_select 'h2', "Edit User"

    post "/admin_dash/edit/user_post/#{user.id}", params:{user:{email:"maike.zhang.com", name:"maikeEdit"}}
    user.update(email:"maike.zhang.com", name:"maikeEdit")
    assert_not user.save
    assert_redirected_to "/admin_dash/edit/user/#{user.id}"
  end

  test "edit user with incorrect name format validated is not valid" do
    create_user
    user = User.find_by_email("user@test.com")

    get "/admin_dash/edit/user/#{user.id}"
    assert_select 'h2', "Edit User"

    post "/admin_dash/edit/user_post/#{user.id}", params:{user:{email:"maike.zhang@gmail.com", name:"maikeEdit123"}}
    user.update(email:"maike.zhang@gmail.com", name:"maikeEdit123")
    assert_not user.save
    assert_redirected_to "/admin_dash/edit/user/#{user.id}"
  end

  test "edit name for account with all parameters validated is valid" do
    create_account
    account = Account.find_by_name('testAccount')
    get "/admin_dash/edit/account/#{account.id}"
    assert_select 'h2', "Edit Account"

    post "/admin_dash/edit/account_post/#{account.id}", params:{account:{name:"maike.zhangEdit", currency:"$"}}
    account.update(name:"maike.zhangEdit", currency:"$")
    assert account.save
    assert_redirected_to "/admin_dash/user/#{account.user_id}"
  end

  test "edit amount, description, time for transaction with all parameters validated is valid" do
    create_transaction
    transaction = Transaction.find_by_amount(-10)
    account = transaction.account
    get "/admin_dash/edit/transaction/#{transaction.id}"
    assert_select 'h2', "Edit Transaction"
    post "/admin_dash/edit/transaction_post/#{transaction.id}", params:{transaction:{amount: -6, description:"kfc", completed_on: '2020-10-16'}}
    transaction.update(amount: -6, description:"kfc", completed_on: '2020-10-16')
    assert transaction.save
    assert_redirected_to "/admin_dash/account/#{transaction.account_id}"
  end

  test "edit time with wrong format for transaction is not valid" do
    create_transaction
    transaction = Transaction.find_by_amount(-10)
    get "/admin_dash/edit/transaction/#{transaction.id}"
    assert_select 'h2', "Edit Transaction"

    post "/admin_dash/edit/transaction_post/#{transaction.id}", params:{transaction:{amount:-10, description:"tesco", completed_on: '2020-1'}}
    transaction.update(amount:-10, description:"tesco", completed_on: '2020-1')
    assert_not transaction.save
    assert_redirected_to "/admin_dash/edit/transaction/#{transaction.id}"
  end

end
