require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "User with full name and email is valid" do
    user = User.new(email: "1158969792@qq.com", name: 'maike zhang')
    assert user.valid?
  end
end
