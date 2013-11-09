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
    
    def availability(from, to)
      raise ArgumentError, "To cannot be the same or earlier than from." unless from < to
      
      availability = {}
      
      reservations = reservations_overlapping_with_range(from, to, 'confirmed')
      days_reservations, left_edges, right_edges = create_bounded_set(reservations, from, to)

      (from .. to).each do |day|
        state = 'unavailable'
        unless days_reservations.include?(day)
          state = 'available'
        end
        availability[day] = {state: state}
        
        if left_edges.include?(day)
          availability[day][:slope] = "left"
        elsif right_edges.include?(day)
          availability[day][:slope] = "right"
        end
      end
      availability
    end

    private

    def create_bounded_set(entries, from, to)
      days = Set.new
      left_edges = Set.new
      right_edges = Set.new
      entries.each do |entry|
        (entry.from .. entry.to).each do |day|
          if from <= day && day <= to && entry.from < day && day < entry.to
            days.add(day)
          end
        end
        
        if left_edges.include?(entry.to)
          days.add(entry.to)
          left_edges.delete(entry.to)
        else
          right_edges.add(entry.to)
        end
        
        if right_edges.include?(entry.from)
          days.add(entry.from)
          right_edges.delete(entry.from)
        else
          left_edges.add(entry.from)
        end
      end

      return days, left_edges, right_edges
    end

    def reservations_overlapping_with_range(from, to, state)
      @apartment.reservation.where("`from` < ? and `to` > ? and state = ?",
                                   to, from, state).order("`from`").to_a
    end
  end
end
