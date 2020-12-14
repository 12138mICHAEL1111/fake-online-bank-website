require 'test_helper'

class ThemeTest < ActiveSupport::TestCase
  test "theme with all parameters filled with correct validation is valid" do
    theme = Theme.new(name:'banking 101', font:'Times New Roman', buttons_color:"#CC66FF" )
    assert theme.save
  end

  test "theme with no name is not valid" do
    theme = Theme.new(font:'Times New Roman', buttons_color:"#CC66FF" )
    assert_not theme.save
  end

  test "theme with no font is not valid" do
    theme = Theme.new(name:'banking 101', buttons_color:"#CC66FF" )
    assert_not theme.save
  end

  test "theme with no button color is not valid" do
    theme = Theme.new(name:'banking 101', font:'Times New Roman')
    assert_not theme.save
  end
end
