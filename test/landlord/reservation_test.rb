require 'date'
require './test/test_helper'

class ReservationTest < Minitest::Test
  def setup
    super
    @apartment = Model::Apartment.create!(name: "The apartment")
    @example_data = {apartment_id: @apartment.id,
                     first_name: 'John',
                     last_name: 'Doe',
                     email: 'john@doe.com',
                     from: Date.new(2013, 2, 13),
                     to: Date.new(2013, 2, 18),
                     state: 'unconfirmed'}
  end

  def test_valid_reservation_creation
    Model::Reservation.create!(@example_data)
  end

  def test_invalid_email
    invalid_data = @example_data.clone
    invalid_data[:email] = "some.invalid.email"
    assert_raises(ActiveRecord::RecordInvalid) do
      Model::Reservation.create!(invalid_data)
    end
  end
  
  def test_unique_id
    r1 = Model::Reservation.create!(@example_data)
    r2_data = @example_data.clone
    r2_data[:from] = Date.new(2013, 7, 1)
    r2_data[:to] = Date.new(2013, 7, 3)
    r2 = Model::Reservation.create!(r2_data)
    refute_equal r1.uid, r2.uid
  end
end
