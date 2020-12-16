require 'test_helper'

class AdminDashControllerTest < ActionDispatch::IntegrationTest

  include AdminDashHelper

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

  test "should get users with admin logged in" do
    create_admin_user
    get '/admin_dash'
    assert_response :success
  end

  test 'should redirect to sign in' do
    get '/admin_dash'
    assert_redirected_to '/'
  end

  test 'should get accounts of user with admin logged in' do
    create_user
    user = User.find_by_email("user@test.com")
    get "/admin_dash/user/#{user.id}"

    assert_response :success
  end

  test 'should get transactions of users with admin logged in' do
    create_account
    account = Account.find_by_name("testAccount")
    get "/admin_dash/account/#{account.id}"

    assert_response :success
  end

  # test helper
  test 'should generate 5 new transactions' do
    create_account
    account = Account.find_by_name("testAccount")
    assert_difference 'Transaction.count', 5 do
      generateTransactionArray(account.id)
    end
  end
end
