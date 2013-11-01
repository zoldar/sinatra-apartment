require 'active_support' # Must be required before active_record
require 'active_record'

require 'landlord/validators'
require 'landlord/apartment'
require 'landlord/schedule_entry'
require 'landlord/schedule'
require 'landlord/reservation'

ActiveRecord::Base.logger = Logger.new(STDOUT)

require 'db/connection'
DB::Connection.establish

class LandLord
end
