require 'test_helper'

class UserTest < Minitest::Unit::TestCase
  def setup
    @user = User.new(github_username: "tobiasahlin")
  end

  def test_that_user_can_have_github_username
    assert_equal "tobiasahlin", @user.github_username
  end
  
end
