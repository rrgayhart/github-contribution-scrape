require 'test_helper'
require 'github_data'

class HistoryTest < Minitest::Unit::TestCase
  include GitFake

  def setup
    @history = History.new("mhartl")
    @history.user_hash = self.stub_user_detail
  end

  def test_it_generates_main_url_for_user
    assert_equal @history.user_link, "https://api.github.com/users/mhartl"
  end

  def test_it_gets_user_detail_hash
    assert_equal Hash, @history.user_detail_hash(@history.user_link).class
  end

  def test_it_returns_user_created_date
    assert_equal "Thu, 10 Apr 2008".to_date, @history.user_created_date
  end

  def test_new_user_method_tests_false_for_old_user
    assert_equal false, @history.new_user?
  end

  def test_new_user_method_returns_true_for_new_user
    @history.user_hash["created_at"] = Date.yesterday
    assert_equal true, @history.new_user?
  end
end
