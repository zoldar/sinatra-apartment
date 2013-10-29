module Model
  class Schedule
    def initialize(apartment)
      @apartment = apartment
    end

    def self.for(apartment)
      raise ArgumentError, "Invalid apartment object given" if apartment.nil?
      self.new(apartment)
    end
    
    def available?(from, to)
      raise ArgumentError, "To cannot be the same or earlier than from." unless from <= to
      
      @apartment.schedule_entry.where("`from` <= ? and `to` >= ?", from, to).count > 0
    end
  end
end
