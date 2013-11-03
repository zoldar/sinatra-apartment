module Model
  class ReservationSchedule
    def initialize(apartment)
      @apartment = apartment
    end

    def self.for(apartment)
      raise ArgumentError, "Invalid apartment object given" if apartment.nil?
      self.new(apartment)
    end

    def available?(from, to)
      raise ArgumentError, "To cannot be the same or earlier than from." unless from < to

      !reservations_overlapping_with_range(from, to, 'confirmed').any?
    end

    private

    def reservations_overlapping_with_range(from, to, state)
      @apartment.reservation.where("`from` < ? and `to` > ? and state = ?",
                                   to, from, state).order("`from`").to_a
    end
  end
end
