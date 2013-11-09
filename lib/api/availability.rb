class LandLordAPI < Sinatra::Base
  get '/apartment/default/check/:from/:to' do |from, to|
    check = false
    begin
      check = Model::Availability.for(Model::Apartment.default).
        available?(Date.iso8601(from), Date.iso8601(to))
    rescue ArgumentError
      halt 403, {error: "Invalid dates given."}.to_json
    end
    
    unless check
      halt 403, {error: "Apartment is unavailable for the given period."}
    end

    status 204
  end
  
  get '/apartment/default/availability/:form/:to' do |from, to|
    begin
      availability = Model::Availability.for(Model::Apartment.default).
        availability(Date.iso8601(from), Date.iso8601(to))

      {availability: availability}.to_json
    rescue ArgumentError
      halt 403, {error: "Invalid dates given."}.to_json
    end
  end
end
