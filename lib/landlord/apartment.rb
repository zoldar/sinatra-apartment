module Model
  class Apartment < ActiveRecord::Base
    
    has_many :schedule_entry

    validates :name, presence: true
    validates :name, uniqueness: true
    
    def self.default
      self.first
    end
  end
end
