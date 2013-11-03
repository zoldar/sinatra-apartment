module Model
  class Availability
    def initialize(apartment)
      @apartment = apartment
    end
    
    def self.for(apartment)
      self.new(apartment)
    end
    
    def available?(from, to)
      Schedule.for(apartment).available?(from, to) && 
        ReservationSchedule.for(apartment).available?(from, to)
    end
  end
end
