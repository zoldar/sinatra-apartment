require 'date'
require './test/test_helper'

module TestHelpers
  def fake_reservation(apartment, from, to)
    {apartment_id: apartment.id,
     first_name: 'John',
     last_name: 'Doe',
     email: 'john@doe.com',
     from: from,
     to: to,
     state: 'confirmed'}
  end
end

class BlankReservationScheduleTest < Minitest::Test
  def setup
    super
    @apartment = Model::Apartment.create!(name: "The apartment")
    @schedule = Model::ReservationSchedule.for(@apartment)
  end

  def test_raise_if_nil_for_apartment_given
    assert_raises(ArgumentError) do
      Model::ReservationSchedule.for(nil)
    end
  end

  def test_available_with_empty_schedule
    assert @schedule.available?(Date.new(2013, 4, 7),
                                Date.new(2013, 4, 14))
  end

  def test_raise_in_case_of_faulty_input
    assert_raises(ArgumentError) do
      @schedule.available?(Date.new(2013, 5, 10),
                           Date.new(2013, 5, 5))
    end
  end
end

class SingleReservationScheduleTest < Minitest::Test
  include TestHelpers

  def setup
    super

    @apartment = Model::Apartment.create!(name: "The apartment")
    reservation = fake_reservation(@apartment, Date.new(2013, 2, 13), Date.new(2013, 2, 18))
    Model::Reservation.create!(reservation)
    @schedule = Model::ReservationSchedule.for(@apartment)
  end

  def test_unavailable_when_overlaps
    refute @schedule.available?(Date.new(2013, 2, 11),
                                Date.new(2013, 2, 15))
  end

  def test_available_when_touches_excluded_left_edge
    assert @schedule.available?(Date.new(2013, 2, 10),
                                Date.new(2013, 2, 13))
  end

  def test_available_when_touches_excluded_right_edge
    assert @schedule.available?(Date.new(2013, 2, 18),
                                Date.new(2013, 2, 21))
  end

  def test_available_when_completely_beyond_reservation
    assert @schedule.available?(Date.new(2013, 4, 18),
                                Date.new(2013, 4, 21))
  end
end

class TwoIntermittentReservationScheduleTest < Minitest::Test
  include TestHelpers

  def setup
    super

    @apartment = Model::Apartment.create!(name: "The apartment")
    reservation1 = fake_reservation(@apartment, 
                                    Date.new(2013, 2, 13), 
                                    Date.new(2013, 2, 14))
    Model::Reservation.create!(reservation1)
    reservation2 = fake_reservation(@apartment, 
                                    Date.new(2013, 2, 15), 
                                    Date.new(2013, 2, 18))
    Model::Reservation.create!(reservation2)

    @schedule = Model::ReservationSchedule.for(@apartment)
  end

  def test_available_when_between
    assert @schedule.available?(Date.new(2013, 2, 14),
                                Date.new(2013, 2, 15))
  end
  
  def test_unavailable_when_overlaps
    refute @schedule.available?(Date.new(2013, 2, 13),
                                Date.new(2013, 2, 15))
  end
end

class SingleReservationScheduleAvailabilityTest < Minitest::Test
  include TestHelpers

  def setup
    super

    @apartment = Model::Apartment.create!(name: "The apartment")
    reservation = fake_reservation(@apartment,
                                   Date.new(2013, 2, 13),
                                   Date.new(2013, 2, 18))
    Model::Reservation.create!(reservation)
    @schedule = Model::ReservationSchedule.for(@apartment)
  end

  def test_availability
    days = @schedule.availability(Date.new(2013, 2, 12), Date.new(2013, 2, 19))

    expected = {Date.new(2013, 2, 12) => {state: 'available'},
                Date.new(2013, 2, 13) => {state: 'available', slope: 'left'},
                Date.new(2013, 2, 14) => {state: 'unavailable'},
                Date.new(2013, 2, 15) => {state: 'unavailable'},
                Date.new(2013, 2, 16) => {state: 'unavailable'},
                Date.new(2013, 2, 17) => {state: 'unavailable'},
                Date.new(2013, 2, 18) => {state: 'available', slope: 'right'},
                Date.new(2013, 2, 19) => {state: 'available'}}

    assert_equal expected, days
  end
end

class TwoSideBySideReservationScheduleAvailabilityTest < Minitest::Test
  include TestHelpers

  def setup
    super

    @apartment = Model::Apartment.create!(name: "The apartment")
    reservation1 = fake_reservation(@apartment, 
                                    Date.new(2013, 2, 13), 
                                    Date.new(2013, 2, 15))
    Model::Reservation.create!(reservation1)
    reservation2 = fake_reservation(@apartment, 
                                    Date.new(2013, 2, 15), 
                                    Date.new(2013, 2, 18))
    Model::Reservation.create!(reservation2)

    @schedule = Model::ReservationSchedule.for(@apartment)
  end

  def test_availability
    days = @schedule.availability(Date.new(2013, 2, 12), Date.new(2013, 2, 19))

    expected = {Date.new(2013, 2, 12) => {state: 'available'},
                Date.new(2013, 2, 13) => {state: 'available', slope: 'left'},
                Date.new(2013, 2, 14) => {state: 'unavailable'},
                Date.new(2013, 2, 15) => {state: 'unavailable'},
                Date.new(2013, 2, 16) => {state: 'unavailable'},
                Date.new(2013, 2, 17) => {state: 'unavailable'},
                Date.new(2013, 2, 18) => {state: 'available', slope: 'right'},
                Date.new(2013, 2, 19) => {state: 'available'}}

    assert_equal expected, days
  end
end

class TwoIntermittentReservationScheduleAvailabilityTest < Minitest::Test
  include TestHelpers

  def setup
    super

    @apartment = Model::Apartment.create!(name: "The apartment")
    reservation1 = fake_reservation(@apartment, 
                                    Date.new(2013, 2, 13), 
                                    Date.new(2013, 2, 14))
    Model::Reservation.create!(reservation1)
    reservation2 = fake_reservation(@apartment, 
                                    Date.new(2013, 2, 15), 
                                    Date.new(2013, 2, 18))
    Model::Reservation.create!(reservation2)

    @schedule = Model::ReservationSchedule.for(@apartment)
  end

  def test_availability
    days = @schedule.availability(Date.new(2013, 2, 12), Date.new(2013, 2, 19))

    expected = {Date.new(2013, 2, 12) => {state: 'available'},
                Date.new(2013, 2, 13) => {state: 'available', slope: 'left'},
                Date.new(2013, 2, 14) => {state: 'available', slope: 'right'},
                Date.new(2013, 2, 15) => {state: 'available', slope: 'left'},
                Date.new(2013, 2, 16) => {state: 'unavailable'},
                Date.new(2013, 2, 17) => {state: 'unavailable'},
                Date.new(2013, 2, 18) => {state: 'available', slope: 'right'},
                Date.new(2013, 2, 19) => {state: 'available'}}

    assert_equal expected, days
  end
end
