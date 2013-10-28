module Model
  class DateRangeValidator < ActiveModel::Validator
    def validate(record)
      if record.from >= record.to
        record.errors[:base] << 'From date cannot be the same or later than to date'
      end
    end
  end
end
