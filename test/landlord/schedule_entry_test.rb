require 'date'
require './test/test_helper'

class ScheduleEntryTest < Minitest::Test
  def setup
    super
    @apartment = Model::Apartment.create!(name: "Apartment 3")
  end
  
  def test_valid_entry_creation
    Model::ScheduleEntry.create!(apartment_id: @apartment.id, 
                                 from: Date.new(2013, 2, 13),
                                 to: Date.new(2013, 2, 18),
                                 state: 'available')
  end
  
  def test_to_after_from_should_fail
    assert_raises(ActiveRecord::RecordInvalid) do
      Model::ScheduleEntry.create!(apartment_id: @apartment.id,
                                   from: Date.new(2013, 2, 18),
                                   to: Date.new(2013, 2, 13),
                                   state: 'available')
    end
  end
end
 
