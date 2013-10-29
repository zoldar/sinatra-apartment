require './test/test_helper'

class ApartmentTest < Minitest::Test
  def test_is_name_required
    assert_raises(ActiveRecord::RecordInvalid) do
      Model::Apartment.create!
    end
  end

  def test_is_uniqueness_enforced
    Model::Apartment.create!(name: "Apartment 1")

    assert_raises(ActiveRecord::RecordInvalid) do
      Model::Apartment.create!(name: "Apartment 1")
    end
  end
  
  def test_default_returns_first_apartment
    a1 = Model::Apartment.create!(name: "Apartment 1")
    Model::Apartment.create!(name: "Apartment 2")

    assert_equal Model::Apartment.default, a1
  end
end
