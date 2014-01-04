require File.expand_path '../test_helper.rb', __FILE__


class MyAppTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    GitApp
  end

  def test_it_returns_a_webpage
    get '/'
    assert last_response.ok?
    assert_equal 'Hello World!', last_response.body
  end

end
