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

  def test_availability_for_a_period
    expected = {Date.new(2013, 2, 11) => {state: 'unavailable'},
                Date.new(2013, 2, 12) => {state: 'available'},
                Date.new(2013, 2, 13) => {state: 'available'},
                Date.new(2013, 2, 14) => {state: 'available'},
                Date.new(2013, 2, 15) => {state: 'available'},
                Date.new(2013, 2, 16) => {state: 'available'},
                Date.new(2013, 2, 17) => {state: 'available'},
                Date.new(2013, 2, 18) => {state: 'available'},
                Date.new(2013, 2, 19) => {state: 'available'},
                Date.new(2013, 2, 20) => {state: 'available'},
                Date.new(2013, 2, 21) => {state: 'unavailable'}}
    
    get "/apartment/default/availability/2013-02-11/2013-02-21"
    assert_equal 200, last_response.status
    assert_equal last_response.body, {availability: expected}.to_json
  end
end
