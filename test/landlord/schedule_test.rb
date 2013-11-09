require 'date'
require './test/test_helper'

class BlankScheduleTest < Minitest::Test

  def setup
    super
    @apartment = Model::Apartment.create!(name: "Apartment without schedule")
    @schedule = Model::Schedule.for(@apartment)
  end

  def test_raise_if_nil_for_apartment_given
    assert_raises(ArgumentError) do
      Model::Schedule.for(nil)
    end
  end

  def test_unavailable_with_empty_schedule
    refute @schedule.available?(Date.new(2013, 4, 7),
                                Date.new(2013, 4, 14))
  end

  def test_raise_in_case_of_faulty_input
    assert_raises(ArgumentError) do
      @schedule.available?(Date.new(2013, 5, 10),
                           Date.new(2013, 5, 5))
    end
  end
end

class ScheduleWithOneEntryTest < Minitest::Test
  def setup
    super
    @apartment = Model::Apartment.create!(name: "Apartment with schedule")

    Model::ScheduleEntry.create!(apartment_id: @apartment.id,
                                 from: Date.new(2013, 2, 13),
                                 to: Date.new(2013, 2, 18),
                                 state: 'available')

    @schedule = Model::Schedule.for(@apartment)
  end

  def test_unavailable_outside_entry_bounds
    refute @schedule.available?(Date.new(2013, 5, 14),
                                Date.new(2013, 5, 16))
  end

  def test_available_within_entry_bounds
    assert @schedule.available?(Date.new(2013, 2, 14),
                                Date.new(2013, 2, 16))
  end

  def test_unavailable_when_over_right_edge
    refute @schedule.available?(Date.new(2013, 2, 15),
                                Date.new(2013, 2, 19))
  end

  def test_unavailable_when_over_left_edge
    refute @schedule.available?(Date.new(2013, 2, 11),
                                Date.new(2013, 2, 14))
  end

  def test_unavailable_when_over_both_edges
    refute @schedule.available?(Date.new(2013, 2, 10),
                                Date.new(2013, 2, 20))
  end
end

class ScheduleWithTwoContinuousEntriesTest < Minitest::Test
  def setup
    super

    @apartment = Model::Apartment.create!(name: "Apartment with schedule")

    Model::ScheduleEntry.create!(apartment_id: @apartment.id,
                                 from: Date.new(2013, 2, 13),
                                 to: Date.new(2013, 2, 18),
                                 state: 'available')

    Model::ScheduleEntry.create!(apartment_id: @apartment.id,
                                 from: Date.new(2013, 2, 18),
                                 to: Date.new(2013, 2, 24),
                                 state: 'available')

    @schedule = Model::Schedule.for(@apartment)
  end

  def test_available_when_spans_multiple_entries
    assert @schedule.available?(Date.new(2013, 2, 15),
                                Date.new(2013, 2, 21))
  end

  def test_unavailable_when_spans_multiple_and_over_right_edge
    refute @schedule.available?(Date.new(2013, 2, 15),
                                Date.new(2013, 2, 26))
  end

  def test_unavailable_when_spans_multiple_and_over_left_edge
    refute @schedule.available?(Date.new(2013, 2, 11),
                                Date.new(2013, 2, 23))
  end

  def test_unavailable_when_spans_multiple_and_over_both_edges
    refute @schedule.available?(Date.new(2013, 2, 12),
                                Date.new(2013, 2, 26))
  end

  def test_available_when_contained_in_a_single_entry
    assert @schedule.available?(Date.new(2013, 2, 14),
                                Date.new(2013, 2, 16))
  end

  def test_unavailable_when_completely_outside_entries
    refute @schedule.available?(Date.new(2013, 5, 12),
                                Date.new(2013, 5, 26))
  end

  def test_available_when_covers_the_whole_range_of_entries
    refute @schedule.available?(Date.new(2013, 5, 13),
                                Date.new(2013, 5, 24))
  end
end

class ScheduleWithTwoIntermittentEntriesTest < Minitest::Test
  def setup
    super

    @apartment = Model::Apartment.create!(name: "Apartment with schedule")

    Model::ScheduleEntry.create!(apartment_id: @apartment.id,
                                 from: Date.new(2013, 2, 13),
                                 to: Date.new(2013, 2, 18),
                                 state: 'available')

    Model::ScheduleEntry.create!(apartment_id: @apartment.id,
                                 from: Date.new(2013, 2, 20),
                                 to: Date.new(2013, 2, 24),
                                 state: 'available')

    @schedule = Model::Schedule.for(@apartment)
  end

  def test_unavailable_when_spans_multiple_entries
    refute @schedule.available?(Date.new(2013, 2, 15),
                                Date.new(2013, 2, 21))
  end

  def test_available_when_contained_in_a_single_entry
    assert @schedule.available?(Date.new(2013, 2, 21),
                                Date.new(2013, 2, 23))
  end
end

class ScheduleWithTwoAvailableOverlappingEntriesTest < Minitest::Test
  def setup
    super

    @apartment = Model::Apartment.create!(name: "Apartment with schedule")

    Model::ScheduleEntry.create!(apartment_id: @apartment.id,
                                 from: Date.new(2013, 2, 13),
                                 to: Date.new(2013, 2, 24),
                                 state: 'available')

    Model::ScheduleEntry.create!(apartment_id: @apartment.id,
                                 from: Date.new(2013, 2, 15),
                                 to: Date.new(2013, 2, 20),
                                 state: 'available')

    @schedule = Model::Schedule.for(@apartment)
  end

  def test_available_when_contained_in_both_entries
    assert @schedule.available?(Date.new(2013, 2, 16),
                                Date.new(2013, 2, 18))
  end

  def test_available_when_contained_in_a_single_entry
    assert @schedule.available?(Date.new(2013, 2, 21),
                                Date.new(2013, 2, 23))
  end
end

class ScheduleWithTwoAlternateOverlappingEntriesTest < Minitest::Test
  def setup
    super

    @apartment = Model::Apartment.create!(name: "Apartment with schedule")

    Model::ScheduleEntry.create!(apartment_id: @apartment.id,
                                 from: Date.new(2013, 2, 13),
                                 to: Date.new(2013, 2, 24),
                                 state: 'available')

    Model::ScheduleEntry.create!(apartment_id: @apartment.id,
                                 from: Date.new(2013, 2, 15),
                                 to: Date.new(2013, 2, 20),
                                 state: 'unavailable')

    @schedule = Model::Schedule.for(@apartment)
  end

  def test_unavailable_when_contained_in_both_entries
    refute @schedule.available?(Date.new(2013, 2, 16),
                                Date.new(2013, 2, 18))
  end

  def test_unavailable_when_over_the_edge_of_inner_entry
    refute @schedule.available?(Date.new(2013, 2, 14),
                                Date.new(2013, 2, 18))
  end

  def test_unavailable_when_over_the_edge_of_both_entries
    refute @schedule.available?(Date.new(2013, 2, 14),
                                Date.new(2013, 2, 26))
  end

  def test_available_when_contained_only_in_outer_entry
    assert @schedule.available?(Date.new(2013, 2, 21),
                                Date.new(2013, 2, 23))
  end
end

class ScheduleWithOneEntryAvailabilityTest < Minitest::Test
  def setup
    super
    @apartment = Model::Apartment.create!(name: "Apartment with schedule")

    Model::ScheduleEntry.create!(apartment_id: @apartment.id,
                                 from: Date.new(2013, 2, 13),
                                 to: Date.new(2013, 2, 18),
                                 state: 'available')

    @schedule = Model::Schedule.for(@apartment)
  end
  
  def test_availability_over_both_edges
    days = @schedule.availability(Date.new(2013, 2, 10), Date.new(2013, 2, 20))

    expected = {Date.new(2013, 2, 10) => {state: 'unavailable'},
                Date.new(2013, 2, 11) => {state: 'unavailable'},
                Date.new(2013, 2, 12) => {state: 'unavailable'},
                Date.new(2013, 2, 13) => {state: 'available'},
                Date.new(2013, 2, 14) => {state: 'available'},
                Date.new(2013, 2, 15) => {state: 'available'},
                Date.new(2013, 2, 16) => {state: 'available'},
                Date.new(2013, 2, 17) => {state: 'available'},
                Date.new(2013, 2, 18) => {state: 'available'},
                Date.new(2013, 2, 19) => {state: 'unavailable'},
                Date.new(2013, 2, 20) => {state: 'unavailable'}}

    assert_equal expected, days
  end
end

class ScheduleWithTwoAlternateOverlappingEntriesAvailabilityTest < Minitest::Test
  def setup
    super

    @apartment = Model::Apartment.create!(name: "Apartment with schedule")

    Model::ScheduleEntry.create!(apartment_id: @apartment.id,
                                 from: Date.new(2013, 2, 13),
                                 to: Date.new(2013, 2, 24),
                                 state: 'available')

    Model::ScheduleEntry.create!(apartment_id: @apartment.id,
                                 from: Date.new(2013, 2, 15),
                                 to: Date.new(2013, 2, 20),
                                 state: 'unavailable')

    @schedule = Model::Schedule.for(@apartment)
  end

  def test_availability_over_both_edges
    days = @schedule.availability(Date.new(2013, 2, 12), Date.new(2013, 2, 25))

    expected = {Date.new(2013, 2, 12) => {state: 'unavailable'},
                Date.new(2013, 2, 13) => {state: 'available'},
                Date.new(2013, 2, 14) => {state: 'available'},
                Date.new(2013, 2, 15) => {state: 'unavailable'},
                Date.new(2013, 2, 16) => {state: 'unavailable'},
                Date.new(2013, 2, 17) => {state: 'unavailable'},
                Date.new(2013, 2, 18) => {state: 'unavailable'},
                Date.new(2013, 2, 19) => {state: 'unavailable'},
                Date.new(2013, 2, 20) => {state: 'unavailable'},
                Date.new(2013, 2, 21) => {state: 'available'},
                Date.new(2013, 2, 22) => {state: 'available'},
                Date.new(2013, 2, 23) => {state: 'available'},
                Date.new(2013, 2, 24) => {state: 'available'},
                Date.new(2013, 2, 25) => {state: 'unavailable'}}

    assert_equal expected, days
  end
end
