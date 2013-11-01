require 'date'
require './test/test_helper'

class ReservationTest < Minitest::Test
  def setup
    super
    @apartment = Model::Apartment.create!(name: "The apartment")
  end

  def test_valid_reservation_creation
    Model::Reservation.create!(apartment_id: @apartment.id,
                               first_name: 'John',
                               last_name: 'Doe',
                               email: 'john@doe.com',
                               from: Date.new(2013, 2, 13),
                               to: Date.new(2013, 2, 18),
                               state: 'unconfirmed')
  end
end
