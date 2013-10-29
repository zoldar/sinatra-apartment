module Model

  class ScheduleEntry < ActiveRecord::Base

    belongs_to :apartment
    
    validates :from, presence: true
    validates :to, presence: true
    validates :state, presence: true
    validates_inclusion_of :state, :in => ['available', 'unavailable']
    validates_with Model::DateRangeValidator
  end
end
