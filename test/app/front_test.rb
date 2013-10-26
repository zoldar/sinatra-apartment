require './test/app_helper'

class FrontTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ApartmentApp
  end
  
  def teardown
    super
    clear_cookies
  end
  
  def test_simple_front
    get "/"
    assert_equal 200, last_response.status
  end
end
