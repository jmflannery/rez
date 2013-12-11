module Rez
  class Address < ActiveRecord::Base
    validates :building_number, presence: true
    validates :street_name, presence: true
    validates :city, presence: true
    validates :state, presence: true
    validates :zip_code, presence: true
  end
end
