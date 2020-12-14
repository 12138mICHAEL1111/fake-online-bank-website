require 'test_helper'

class SignInTest < ActionDispatch::IntegrationTest
  test "redirects user to dash on valid login" do
    get "/sign_in"

    user = User.new(email:'signin_test@gmail.com', name:'jure', password:'123456', password_confirmation:'123456')
    assert user.save

    post "/sign_in_post", params: { email: 'signin_test@gmail.com', password: "123456" }

    assert_redirected_to "/dash"
  end

  test "redirects admin user to admin dash on valid login" do
    get "/sign_in"

    user = User.new(email:'signin_test+admin@gmail.com', name:'jure', password:'123456', password_confirmation:'123456', admin: true)
    assert user.save

    post "/sign_in_post", params: { email: 'signin_test+admin@gmail.com', password: "123456" }

    assert_redirected_to "/admin_dash"
  end

  test "errors on unvalid email" do
    get "/sign_in"

    post "/sign_in_post", params: { email: 'nobody@gmail.com', password: "123456" }

    assert_redirected_to "/sign_in"
  end

  test "errors on unvalid password" do
    get "/sign_in"

    user = User.new(email:'signin_test@gmail.com', name:'jure', password:'123456', password_confirmation:'123456')
    assert user.save

    post "/sign_in_post", params: { email: 'signin_test@gmail.com', password: "wrongpassword" }

    assert_redirected_to "/sign_in"
  end
end
