module Model
  class Reservation < ActiveRecord::Base
    belongs_to :apartment

    validates :first_name, :last_name, :email, :from, :to, :state, presence: true
    validates_email_format_of :email
    validates_inclusion_of :state, :in => ['unconfirmed', 'confirmed']
    validates_with Model::DateRangeValidator
    
    after_create do
      self.uid = self.id
      self.save
    end
  end
end
