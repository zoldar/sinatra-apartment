module Model

  class ScheduleEntry < ActiveRecord::Base

    belongs_to :apartment
    
    validates :from, :to, :state, presence: true
    validates_inclusion_of :state, :in => ['available', 'unavailable']
    validates_with Model::DateRangeValidator
  end
end
