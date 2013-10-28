require './test/app_helper'

class FrontAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    LandLordApp
  end

  def teardown
    super
    clear_cookies
  end

  def test_front
    get "/"
    assert_equal 200, last_response.status
  end

end
