module Rez
  class AddressSerializer < ActiveModel::Serializer
    attributes :id,
      :building_number,
      :street_name,
      :secondary_address,
      :city,
      :state,
      :zip_code,
      :county,
      :country,
      :area_code,
      :phone_number
  end
end
