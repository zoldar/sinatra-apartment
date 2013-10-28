require 'date'
require './test/test_helper'

class ScheduleEntryTest < Minitest::Test
  def setup
    super
    @apartment = Model::Apartment.create(name: "Apartment 3")
    @apartment.save
  end
  
  def teardown
    super
    @apartment = nil
  end

  def test_valid_entry_creation
    s = Model::ScheduleEntry.create(apartment_id: @apartment.id, 
                                    from: Date.new(2013, 2, 13),
                                    to: Date.new(2013, 2, 18),
                                    state: 'available')
    assert_equal true, s.save
  end
  
  def test_to_after_from_should_fail
    s = Model::ScheduleEntry.create(apartment_id: @apartment.id,
                                    from: Date.new(2013, 2, 18),
                                    to: Date.new(2013, 2, 13),
                                    state: 'available')

    assert_equal false, s.save
  end
end
 
