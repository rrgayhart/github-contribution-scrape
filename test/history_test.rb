require 'test_helper'
require 'github_data'

class HistoryTest < Minitest::Unit::TestCase
  include GitFake

  def setup
    @history = History.new
    @user_details = self.stub_user_detail
  end

  def test_it_generates_main_url_for_user
    github_username = "steven"
    assert_equal @history.user_link(github_username), "https://api.github.com/users/steven"
  end

  def test_it_gets_user_detail_hash
    assert_equal Hash, @history.user_detail_hash(@history.user_link("mhartl")).class
  end

  def test_it_returns_user_created_date
    assert_equal "Thu, 10 Apr 2008".to_date, @history.user_created_date(@user_details)
  end

end
