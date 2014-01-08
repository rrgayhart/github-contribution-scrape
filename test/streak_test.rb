require 'test_helper'
require 'github_data'

class StreakTest < Minitest::Unit::TestCase
  include GitFake

  def setup
    @streak = Streak.new("mhartl")
    @streak.user_array = self.stub_history
  end

  def test_contribution_link_formats_username
    assert_equal @streak.contribution_link, "https://github.com/users/mhartl/contributions_calendar_data"
  end

  def test_contributions_today_returns_number
    assert_equal Fixnum, @streak.contributions_today.class
  end

  def test_contributions_today_returns_correct_number
    assert_equal 8, @streak.contributions_today
  end

  def test_contributions_today_unusual_numbers
    @streak.user_array = self.stub_history_short
    assert_equal 0, @streak.contributions_today
    @streak.user_array = self.stub_history_large 
    assert_equal 3000, @streak.contributions_today
  end

  def test_contributions_yesterday
    @streak.user_array = self.stub_history_large 
    assert_equal 3, @streak.contributions_yesterday
  end

  def test_current_streak_normal
    assert_equal 1, @streak.current_streak
  end

  def test_current_streak_no_commits
    @streak.user_array = self.stub_history_short
    assert_equal 0, @streak.current_streak
  end

  def test_current_streak_no_commits_today
    @streak.user_array = self.stub_history_taking_a_break
    assert_equal 3, @streak.current_streak
  end

  def test_days_without_contributions_returns_correct_days
    assert_equal 245, @streak.days_without_contributions
  end

  def test_days_with_contributions_returns_correct_days
    assert_equal 121, @streak.days_with_contributions
  end

  def test_days_with_and_without_contributions_add_up_correctly
    assert_equal 366, @streak.days_without_contributions + @streak.days_with_contributions
  end

  def test_select_recent_sates_pulls_most_recent_commits
    assert_equal @streak.select_recent_dates(2), [["2014/01/04", 8], ["2014/01/03", 0]]
  end

  def test_select_recent_dates_pulls_per_number
    assert_equal 3, @streak.select_recent_dates(3).count
  end

  def test_year_returns_default_of_this_year
    assert_equal Date.today.year, @streak.year
    assert_equal 2012, @streak.year(2012) 
  end

  def test_days_this_year_without_contributions_returns_days
    assert_equal 3, @streak.days_this_year_without_contributions
  end

  def test_days_this_year_with_contributions_returns_days
    assert_equal 1, @streak.days_this_year_with_contributions
  end

  def test_comparison_this_year
    days_in_the_year = Date.today.yday
    comparisons = {:total_days=>days_in_the_year, :contributions=>1}
    assert_equal comparisons, @streak.comparison_this_year
  end

  def test_comparison_years_time_returns_percentage_per_array_size
    comparisons = {:total_days=>366, :contributions=>121}
    assert_equal comparisons, @streak.comparison_years_time
  end

  def test_percentage_commits_per_year_returns_percentage
    assert_equal 0.5, @streak.percentage_commits_per_year({:total_days=>10, :contributions=>5})
  end

  def test_array_since_joining_returns_arry_of_days_since_joining
    history = History.new("newuser")
    stub = self.stub_user_detail
    past_date = Time.now - 60*60*24*14
    stub["created_at"] = past_date
    history.user_hash = stub
    assert_equal "boo", @streak.array_since_joining(history)
  end

end
