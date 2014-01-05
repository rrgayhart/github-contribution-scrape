require 'test_helper'
require 'github_data'

class StreakTest < Minitest::Unit::TestCase
  include GitFake

  def setup
    @streak = Streak.new
    @stub_array = self.stub_history
    @stub_zero_contributions = self.stub_history_short
    @stub_many_contributions = self.stub_history_large
  end

  def test_contribution_link_formats_username
    github_username = "steven"
    assert_equal @streak.contribution_link(github_username), "https://github.com/users/steven/contributions_calendar_data"
  end

  def test_contributions_today_returns_number
    assert_equal @streak.get_contributions_array("url", @stub_array), "boo"
  end

  def test_contributions_today_returns_number
    assert_equal 8, @streak.contributions_today("url", @stub_array)
  end

  def test_contributions_today_unusual_numbers
    assert_equal 0, @streak.contributions_today("url", @stub_zero_contributions)
    assert_equal 3000, @streak.contributions_today("url", @stub_many_contributions)
  end


end
