require 'test_helper'
require 'github_data'

class StreakTest < Minitest::Unit::TestCase
  include GitFake

  def setup
    @streak = Streak.new
    @stub_array = self.stub_history
    @stub_zero_contributions = self.stub_history_short
    @stub_many_contributions = self.stub_history_large
    @stub_break_time = self.stub_history_taking_a_break
    @url = @streak.contribution_link("rrgayhart")
  end

  def test_contributions_yesterday
    #actual connection to github
    #assert_equal @streak.contributions_yesterday(@url), 2
    assert_equal 3, @streak.contributions_yesterday("url", @stub_many_contributions)
  end

  def test_current_streak
    assert_equal 0, @streak.current_streak("url", @stub_zero_contributions)
    assert_equal 3, @streak.current_streak("url", @stub_break_time)
    assert_equal 4, @streak.current_streak("url", @stub_many_contributions)
    assert_equal 1, @streak.current_streak("url", @stub_array)
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

  def test_year_returns_default_of_this_year
    assert_equal Date.today.year, @streak.year
    assert_equal 2012, @streak.year(2012) 
  end


end
