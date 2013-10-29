require 'landlord'

require 'app/front'

class LandLordApp < Sinatra::Base

  set :root, 'lib/app'
  set :method_override, true

  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { "Need to know only." }
  use Rack::Flash
end
