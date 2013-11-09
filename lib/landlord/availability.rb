module Model
  class Availability
    def initialize(apartment)
      @apartment = apartment
    end
    
    def self.for(apartment)
      self.new(apartment)
    end
    
    def available?(from, to)
      Schedule.for(@apartment).available?(from, to) && 
        ReservationSchedule.for(@apartment).available?(from, to)
    end
    
    def availability(from, to)
      schedule_map = Schedule.for(@apartment).availability(from, to)
      reservation_map = ReservationSchedule.for(@apartment).availability(from, to)

      reservation_map.merge(schedule_map) do |key, reservation_entry, schedule_entry|
        if schedule_entry[:state] == 'unavailable'
          schedule_entry
        else
          reservation_entry
        end
      end
    end
  end
end
