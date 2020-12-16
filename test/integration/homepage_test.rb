require 'test_helper'

class HomepageTest < ActionDispatch::IntegrationTest
  test "homepage is has name" do
    get "/"

    assert_select "h1", Theme.find(1).name
  end

  test "homepage is has sign in button" do
    get "/"

    assert_select "input"
  end
end
