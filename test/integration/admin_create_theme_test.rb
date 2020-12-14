require 'test_helper'

class AdminCreateThemeTest < ActionDispatch::IntegrationTest
  test "admin should be able to edit theme" do
    # Login
    user = User.new(email:'create_user_test_admin@gmail.com', name:'jure', password:'123456', password_confirmation:'123456', admin: true)
    assert user.save

    get "/sign_in"
    post "/sign_in_post", params: { email: 'create_user_test_admin@gmail.com', password: "123456" }
    assert_redirected_to "/admin_dash"

    # Edit theme
    get "/admin_dash/look_and_feel"
    assert_select "h2", "Edit look and feel"

    post "/admin_dash/edit/look_and_feel", params: {theme: {name: "New bank name.", font: "Arial", buttons_color: "green"}}
    assert_redirected_to "/admin_dash/look_and_feel"

    assert_select "input[value=?]",  "New bank name."
  end
end
