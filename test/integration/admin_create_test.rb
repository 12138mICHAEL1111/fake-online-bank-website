require 'test_helper'

class AdminCreateTest < ActionDispatch::IntegrationTest
  test "admin should be able to create a user" do
    # Login
    user = User.new(email:'create_user_test_admin@gmail.com', name:'jure', password:'123456', password_confirmation:'123456', admin: true)
    assert user.save

    get "/sign_in"
    post "/sign_in_post", params: { email: 'create_user_test_admin@gmail.com', password: "123456" }
    assert_redirected_to "/admin_dash"

    # Create user
    get "/admin_dash/create/user"
    assert_select "h2", "Create User"

    post "/admin_dash/create/user_post", params: {user: {email: "create_user_test_user@gmail.com", password: "123456", name: "John"}}
    assert_redirected_to "/admin_dash"
  end

  test "admin shouldn't be able to create a user with wrong email" do
    # Login
    user = User.new(email:'create_user_test_admin@gmail.com', name:'jure', password:'123456', password_confirmation:'123456', admin: true)
    assert user.save

    get "/sign_in"
    post "/sign_in_post", params: { email: 'create_user_test_admin@gmail.com', password: "123456" }
    assert_redirected_to "/admin_dash"

    # Create user
    get "/admin_dash/create/user"
    assert_select "h2", "Create User"

    post "/admin_dash/create/user_post", params: {user: {email: "not an email", password: "123456", name: "John"}}
    assert_redirected_to "/admin_dash/create/user"
  end

  test "admin should be able to create an account" do
    # Login
    user = User.new(email:'create_user_test_admin@gmail.com', name:'jure', password:'123456', password_confirmation:'123456', admin: true)
    assert user.save

    get "/sign_in"
    post "/sign_in_post", params: { email: 'create_user_test_admin@gmail.com', password: "123456" }
    assert_redirected_to "/admin_dash"

    # Create user
    get "/admin_dash/create/user"
    assert_select "h2", "Create User"

    post "/admin_dash/create/user_post", params: {user: {email: "create_user_test_user@gmail.com", password: "123456", name: "John"}}
    assert_redirected_to "/admin_dash"

    # Create Account
    createdUser = User.find_by_email("create_user_test_user@gmail.com")
    get '/admin_dash/create/account/' + createdUser.id.to_s

    post "/admin_dash/create/account_post/" + createdUser.id.to_s, params: {account: {name: "savings", currency: "$"}}
    assert_redirected_to '/admin_dash/user/' + createdUser.id.to_s
  end

  test "admin should be able to create a transaction" do
    # Login
    user = User.new(email:'create_user_test_admin@gmail.com', name:'jure', password:'123456', password_confirmation:'123456', admin: true)
    assert user.save

    get "/sign_in"
    post "/sign_in_post", params: { email: 'create_user_test_admin@gmail.com', password: "123456" }
    assert_redirected_to "/admin_dash"

    # Create user
    get "/admin_dash/create/user"
    assert_select "h2", "Create User"

    post "/admin_dash/create/user_post", params: {user: {email: "create_user_test_user@gmail.com", password: "123456", name: "John"}}
    assert_redirected_to "/admin_dash"

    # Create Account
    createdUser = User.find_by_email("create_user_test_user@gmail.com")
    get '/admin_dash/create/account/' + createdUser.id.to_s

    post "/admin_dash/create/account_post/" + createdUser.id.to_s, params: {account: {name: "savings", currency: "$"}}
    assert_redirected_to '/admin_dash/user/' + createdUser.id.to_s

    # Create Transaction
    createdAccount = User.find_by_email("create_user_test_user@gmail.com").accounts.first
    get '/admin_dash/create/transaction/' + createdAccount.id.to_s

    post "/admin_dash/create/transaction_post/" + createdAccount.id.to_s, params: {transaction: {ammount: 100, description: "test", completed_on: DateTime.now}}
    assert_redirected_to '/admin_dash/create/transaction/' + createdAccount.id.to_s
  end
end
