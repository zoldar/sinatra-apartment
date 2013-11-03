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
      raise ArgumentError, "To cannot be the same or earlier than from." unless from < to

      entries_available = entries_overlapping_with_range('available', from, to)
      entries_unavailable = entries_overlapping_with_range('unavailable', from, to)

      contained_in_available_entries?(entries_available, from, to) &&
        !entries_unavailable.any?
    end
    
    private
    
    def contained_in_available_entries?(entries, from, to)
      entries.any? && 
        entries_contain_range?(entries, from, to) && 
        continuous?(entries)
    end

    def entries_overlapping_with_range(state, from, to)
      @apartment.schedule_entry.where("`from` <= ? and `to` >= ? and state = ?", 
                                      to, from, state).order("`from`").to_a
    end
    
    def entries_contain_range?(entries, from, to)
      entries.first.from <= from && entries.last.to >= to
    end
    
    def continuous?(entries)
      continuity_flag = true
      previous_entry = nil
      entries.each do |entry|
        if !previous_entry.nil? && entry.from > previous_entry.to
          continuity_flag = false
          break
        end
        previous_entry = entry
      end
      continuity_flag
    end
  end
end
