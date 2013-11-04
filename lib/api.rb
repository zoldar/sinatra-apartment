require 'landlord'
require 'sinatra/petroglyph'

require 'api/availability'

class LandLordAPI < Sinatra::Base
  set :environment, ENV.fetch('RACK_ENV') { :development }.to_sym
  set :root, 'lib/api'
  set :method_override, true

  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { "Need to know only." }
  use Rack::Flash
end
