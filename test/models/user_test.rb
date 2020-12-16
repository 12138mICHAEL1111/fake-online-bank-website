require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user with all parameters validated  is valid" do
    user = User.new(email:'maike.zhang@gmail.com',name:'maike.zhang',password:'123456',password_confirmation:'123456')
    assert user.save
  end

  test "user with wrong password confirmation is not valid" do
    user = User.new(email:'maike.zhang@gmail.com',name:'maike',password:'123456', password_confirmation:'1234567')
    assert_not user.save
  end

  test "user with no email is not valid" do
    user = User.new(name:'maike',password:'123456',password_confirmation:'123456')
    assert_not user.save
  end

  test "user with email which is already exists is not valid" do
    preSetUser = users(:testUser)
    user = User.new(name:'maike',password:'123456',email:preSetUser.email,password_confirmation:'123456')
    assert_not user.save
  end

  test "user with no password is not valid" do
    user = User.new(name:'maike',email:'maike.zhang@gmail.com',password_confirmation:'123456')
    assert_not user.save
  end

  test "user with incorrect email format(lack of @) is not valid" do
    user = User.new(name:'maike',email:'maike.zhanggmail.com',password:'123456',password_confirmation:'123456')
    assert_not user.save
  end

  test "user with incorrect email format(lack of .com or something else) is not valid" do
    user = User.new(name:'maike',email:'maike.zhang@gmail',password:'123456',password_confirmation:'123456')
    assert_not user.save
  end

  test "user with name contains number is not valid" do
    user = User.new(name:'maike123',email:'maike.zhang@gmail.com',password:'123456',password_confirmation:'123456')
    assert_not user.save
  end

  test "user with special character number is not valid" do
    user = User.new(name:'maike#',email:'maike.zhang@gmail.com',password:'123456',password_confirmation:'123456')
    assert_not user.save
  end

  test "user with password less than 6 characters is not valid" do
    user = User.new(name:'maike',email:'maike.zhang@gmail.com',password:'12345',password_confirmation:'12345')
    assert_not user.save
  end
end
