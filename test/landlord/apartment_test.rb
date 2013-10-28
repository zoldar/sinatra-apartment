require './test/test_helper'

class ApartmentTest < Minitest::Test
  def test_is_name_required
    a = Model::Apartment.create()
    assert_equal a.save, false
  end

  def test_is_uniqueness_enforced
    a1 = Model::Apartment.create(name: "Apartment 1")
    a1.save

    a2 = Model::Apartment.create(name: "Apartment 1")
    assert_equal false, a2.save
  end
  
  def test_default_returns_first_apartment
    a1 = Model::Apartment.create(name: "Apartment 1")
    a1.save()

    a2 = Model::Apartment.create(name: "Apartment 2")
    a2.save()

    assert_equal Model::Apartment.default, a1
  end
end
