require 'apartment_site'

require 'app/front'

class ApartmentApp < Sinatra::Base

  set :root, 'lib/app'
  set :method_override, true

  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { "Need to know only." }
  use Rack::Flash

  helpers do

    def site_root
      if ENV['RACK_ENV'].to_sym == :production
        ENV.fetch('SITE_ROOT') { "http://apartment.zoldar.net" }
      else
        'http://localhost:4567'
      end
    end
  end
end
