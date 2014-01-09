require 'test_helper'

class UserTest < Minitest::Unit::TestCase
  def setup
    @user = User.new(github_username: "tobiasahlin")
  end

  def test_that_user_can_have_github_username
    assert_equal "tobiasahlin", @user.github_username
  end

  def test_adding_all_contribution_history_formats_correctly
    @user.add_all_contribution_history
    assert_equal 366, @user.contribution_history.count
  end

end
