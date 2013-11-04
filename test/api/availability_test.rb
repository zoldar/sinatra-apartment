require 'date'
require './test/app_helper'

class AvailabilityAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    LandLordAPI
  end

  def setup
    super

    apartment = Model::Apartment.create!(name: "The apartment")
    Model::ScheduleEntry.create!(apartment_id: apartment.id,
                                 from: Date.new(2013, 2, 12),
                                 to: Date.new(2013, 2, 20),
                                 state: 'available')
  end

  def teardown
    super
    clear_cookies
  end

  def test_check_with_valid_dates
    get "/apartment/default/check/2013-02-15/2013-02-19"
    assert_equal 204, last_response.status
  end
  
  def test_check_with_invalid_dates
    get "/apartment/default/check/2013-02-15/2013-02-13"
    assert_equal 403, last_response.status
  end
  
  def test_check_over_the_edge
    get "/apartment/default/check/2013-02-15/2013-02-25"
    assert_equal 403, last_response.status
  end
end
