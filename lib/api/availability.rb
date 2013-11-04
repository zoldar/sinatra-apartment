class LandLordAPI < Sinatra::Base
  get '/apartment/default/check/:from/:to' do |from, to|
    check = false
    begin
      check = Model::Availability.for(Model::Apartment.default).
        available?(Date.iso8601(from), Date.iso8601(to))
    rescue ArgumentError
      halt 403, {error: "Invalid dates given."}.to_json
    end
    
    if !check
      halt 403, {error: "Apartment is unavailable for the given period."}
    end

    status 204
  end
end
