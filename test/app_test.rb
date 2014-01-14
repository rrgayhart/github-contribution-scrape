require File.expand_path '../test_helper.rb', __FILE__


class MyAppTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_returns_a_webpage
    get '/'
    assert last_response.ok?
    assert_equal 200, last_response.status
  end

  # test_it_returns_a_valid_user_json_page

  # test_it_returns_an_json_error_if_user_doesnt_exist

end
