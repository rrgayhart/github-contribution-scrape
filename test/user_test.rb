require 'test_helper'

class UserTest < Minitest::Unit::TestCase
  def setup
    @user = User.new
  end

  def test_that_user_can_have_github_username
    assert_equal "rrgayhart", @user.name
  end
end
