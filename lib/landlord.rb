require 'active_support' # Must be required before active_record
require 'active_record'

require 'landlord/apartment'

require 'db/connection'
DB::Connection.establish

class LandLord
end
