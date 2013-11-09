module ModelHelpers
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
