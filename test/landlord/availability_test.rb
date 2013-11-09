require 'date'
require './test/test_helper'
require './test/model_helpers'

class EmptyAvailabilityTest < Minitest::Test
  def setup
    super
    @apartment = Model::Apartment.create!(name: "The apartment")
    @availability = Model::Availability.for(@apartment)
  end

  def test_unavailable_for_random_period
    refute @availability.available?(Date.new(2013, 2, 10),
                                    Date.new(2013, 2, 20))
  end

  def test_availability_for_whole_year
    expected = {}
    (Date.new(2013, 1, 1) .. Date.new(2013, 12, 31)).each do |day|
      expected[day] = {:state => 'unavailable'}
    end

    actual = @availability.availability(Date.new(2013, 1, 1),
                                        Date.new(2013, 12, 31))

    assert_equal expected, actual
  end
end

class ScheduleOnlyAvaiabilityTest < Minitest::Test
  def setup
    super
    @apartment = Model::Apartment.create!(name: "The apartment")

    Model::ScheduleEntry.create!(apartment_id: @apartment.id,
                                 from: Date.new(2013, 2, 13),
                                 to: Date.new(2013, 2, 24),
                                 state: 'available')

    @availability = Model::Availability.for(@apartment)
  end

  def test_availability_for_whole_year
    expected = {}

    (Date.new(2013, 1, 1) .. Date.new(2013, 2, 12)).each do |day|
      expected[day] = {:state => 'unavailable'}
    end

    (Date.new(2013, 2, 13) .. Date.new(2013, 2, 24)).each do |day|
      expected[day] = {:state => 'available'}
    end

    (Date.new(2013, 2, 25) .. Date.new(2013, 12, 31)).each do |day|
      expected[day] = {:state => 'unavailable'}
    end

    actual = @availability.availability(Date.new(2013, 1, 1),
                                        Date.new(2013, 12, 31))

    assert_equal expected, actual
  end
end

class CombinedAvailabilityTest < Minitest::Test
  include ModelHelpers

  def setup
    super
    @apartment = Model::Apartment.create!(name: "The apartment")

    Model::ScheduleEntry.create!(apartment_id: @apartment.id,
                                 from: Date.new(2013, 2, 13),
                                 to: Date.new(2013, 2, 24),
                                 state: 'available')

    reservation = fake_reservation(@apartment,
                                   Date.new(2013, 2, 20),
                                   Date.new(2013, 2, 27))

    Model::Reservation.create!(reservation)

    @availability = Model::Availability.for(@apartment)
  end

  def test_availability_for_a_period
    expected = {Date.new(2013, 2, 12) => {state: 'unavailable'},
                Date.new(2013, 2, 13) => {state: 'available'},
                Date.new(2013, 2, 14) => {state: 'available'},
                Date.new(2013, 2, 15) => {state: 'available'},
                Date.new(2013, 2, 16) => {state: 'available'},
                Date.new(2013, 2, 17) => {state: 'available'},
                Date.new(2013, 2, 18) => {state: 'available'},
                Date.new(2013, 2, 19) => {state: 'available'},
                Date.new(2013, 2, 20) => {state: 'available', slope: 'left'},
                Date.new(2013, 2, 21) => {state: 'unavailable'},
                Date.new(2013, 2, 22) => {state: 'unavailable'},
                Date.new(2013, 2, 23) => {state: 'unavailable'},
                Date.new(2013, 2, 24) => {state: 'unavailable'},
                Date.new(2013, 2, 25) => {state: 'unavailable'},
                Date.new(2013, 2, 26) => {state: 'unavailable'},
                Date.new(2013, 2, 27) => {state: 'unavailable'},
                Date.new(2013, 2, 28) => {state: 'unavailable'}}
    
    actual = @availability.availability(Date.new(2013, 2, 12),
                                        Date.new(2013, 2, 28))

    assert_equal expected, actual
  end
end
