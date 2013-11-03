require 'date'
require './test/test_helper'

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
  def setup
    super

    @apartment = Model::Apartment.create!(name: "The apartment")
    example_data = {apartment_id: @apartment.id,
                    first_name: 'John',
                    last_name: 'Doe',
                    email: 'john@doe.com',
                    from: Date.new(2013, 2, 13),
                    to: Date.new(2013, 2, 18),
                    state: 'confirmed'}
    Model::Reservation.create!(example_data)
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
